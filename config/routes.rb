Spree::Core::Engine.routes.draw do
  namespace :admin do
    resources :subscription_intervals
    resources :subscriptions, :except => [:new,:create]
  end

  resources :subscriptions, :only => [:destroy]

end
