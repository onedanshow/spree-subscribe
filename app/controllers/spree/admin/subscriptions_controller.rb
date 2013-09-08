module Spree
  module Admin
    class SubscriptionsController < Spree::Admin::BaseController

      def index
        @search = Spree::Subscription.post_cart.ransack(params[:q])
        @subscriptions = @search.result.includes([:user]).
          page(params[:page]).
          per(params[:per_page] || Spree::Config[:orders_per_page])
      end

      def edit

      end
    end
  end
end
