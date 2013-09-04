class Spree::ClientSubscriptionIntervalsController < Spree::StoreController

  def create
    subscription = Spree::SubscriptionInterval.find_by_name(params[:subscription_interval][:name])

    subscription = Spree::SubscriptionInterval.create(subscription_params) unless subscription

    add_product_interval(params[:subscription_interval][:product_id], subscription.id)

    render json:  subscription, status: :ok
  end

  private
  def add_product_interval(product_id, subscription_id)
    product = Spree::Product.find(product_id)
    product.spree_subscription_interval_products.create(subscription_interval_id: subscription_id)
    product.subscribable = true
    product.save
  end

  def subscription_params
    params[:subscription_interval].except('product_id')
  end
end
