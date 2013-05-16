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

  private

  def add_subscription(variant_id, interval_id)
    line_item = current_order.line_items.where(:variant_id => variant_id).first

    # DD: set subscribed price
    if line_item.variant.subscribed_price.present?
      line_item.price = line_item.variant.subscribed_price
    end

    # DD: create subscription
    if line_item.subscription
      line_item.subscription.update_attributes :interval_id => interval_id
    else
      line_item.subscription = Spree::Subscription.create :interval_id => interval_id
    end

    line_item.save

    line_item.subscription
  end

end