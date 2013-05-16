class Spree::Admin::SubscriptionsController < Spree::Admin::ResourceController

  def index
    # DD: stolen from Spree::Admin::OrdersController
    @search = Spree::Subscription.ransack(params[:q])
    @subscriptions = @search.result.includes([:user]).
      page(params[:page]).
      per(params[:per_page] || Spree::Config[:orders_per_page])
  end
end
