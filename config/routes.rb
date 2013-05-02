Spree::Core::Engine.routes.draw do
  namespace :admin do
    resources :subscription_intervals
    resources :subscriptions, :except => [:new,:create]
  end

  namespace :spree do
    resources :subscriptions, :only => [:edit,:update,:destroy]
  end

end
