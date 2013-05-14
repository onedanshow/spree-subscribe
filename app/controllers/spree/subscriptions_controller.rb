class Spree::SubscriptionsController < Spree::StoreController
  rescue_from ActiveRecord::RecordNotFound, :with => :render_404
  load_and_authorize_resource :class => Spree::Subscription

  def destroy
    @subscription.active? ? @subscription.suspend : @subscription.resume

    redirect_to account_url
  end

end
