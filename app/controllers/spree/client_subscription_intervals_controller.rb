class Spree::ClientSubscriptionIntervalsController < Spree::StoreController

  def create
    subscription = find_or_create_subscription subscription_params
    add_product_interval(params[:subscription_interval][:product_id], subscription.id)
    render json: subscription, status: :ok
  end

  private
  def add_product_interval(product_id, subscription_id)
    product = Spree::Product.find(product_id)
    unless product.get_subscription_interval(subscription_id)
      product.add_subscription_interval subscription_id
    end
  end

  def find_or_create_subscription params
    subscription = Spree::SubscriptionInterval.where(
      times: params[:times],
      time_unit: params[:time_unit]).first
    subscription = Spree::SubscriptionInterval.create(params) unless subscription
    subscription
  end

  def subscription_params
    params[:subscription_interval].except('product_id')
  end

end
