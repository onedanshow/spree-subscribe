class Spree::Admin::SubscriptionIntervalsController < Spree::Admin::ResourceController
  respond_to :html, :json, :js

  def search
    if params[:ids]
      @intervals = Spree::SubscriptionInterval.where(:id => params[:ids].split(','))
    else
      @intervals = Spree::SubscriptionInterval.limit(20).search(:name_cont => params[:q]).result
    end
  end

  def create
    @subscription = Spree::SubscriptionInterval.where(name: params[:subscription_interval][:name]).first

    @subscription = Spree::SubscriptionInterval.create(name: params[:subscription_interval][:name], 
                                                       times: params[:subscription_interval][:times], 
                                                       time_unit: params[:subscription_interval][:time_unit]) unless @subscription

    product = Spree::Product.find(params[:subscription_interval][:product_id])
    product.spree_subscription_interval_products.create(subscription_interval_id: @subscription.id)
    product.subscribable = 1
    product.save

    render json:  @subscription, status: :ok

  end
end
