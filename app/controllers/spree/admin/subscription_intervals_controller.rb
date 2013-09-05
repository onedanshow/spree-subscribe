class Spree::Admin::SubscriptionIntervalsController < Spree::Admin::ResourceController
  respond_to :html, :json, :js

  def search
    if params[:ids]
      @intervals = Spree::SubscriptionInterval.where(:id => params[:ids].split(','))
    else
      @intervals = Spree::SubscriptionInterval.limit(20).search(:name_cont => params[:q]).result
    end
  end
end
