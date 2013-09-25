Spree::OrdersController.class_eval do
  after_filter :check_subscriptions, :only => [:populate]

  protected

  # DD: maybe use a format close to OrderPopulator (or move to or decorate there one day)
  # +:subscriptions => { variant_id => interval_id, variant_id => interval_id }
  def check_subscriptions
    return unless params[:subscriptions] && params[:subscriptions][:active].to_s == "1"

    params[:products].each do |product_id,variant_id|
      add_subscription variant_id, params[:subscriptions][:interval_id]
    end if params[:products]

    params[:variants].each do |variant_id, quantity|
      add_subscription variant_id, params[:subscriptions][:interval_id]
    end if params[:variants]
  end

  protected

  # DD: TODO write test for this method
  def add_subscription(variant_id, interval_id)
    line_item = current_order.line_items.where(:variant_id => variant_id).first
    if line_item
      interval = Spree::SubscriptionInterval.find(interval_id)

      # DD: set subscribed price
      subscribed_price = line_item.variant.subscribed_price(interval_id)
      line_item.price = subscribed_price if subscribed_price

      # DD: create subscription
      if line_item.subscription
        line_item.subscription.update_attributes :times => interval.times, :time_unit => interval.time_unit
      else
        line_item.subscription = Spree::Subscription.create :times => interval.times, :time_unit => interval.time_unit
      end

      line_item.save

      line_item.subscription
    end
  end

end
