Spree::Admin::ProductsController.class_eval do
  before_filter :check_subscription_intervals, :only => [:update]

  protected

  def check_subscription_intervals
    if params[:product][:subscription_interval_ids].present?
      params[:product][:subscription_interval_ids] = params[:product][:subscription_interval_ids].split(',')
    end
  end

end