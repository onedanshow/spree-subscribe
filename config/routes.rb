Spree::Core::Engine.routes.draw do
  namespace :admin do
    resources :subscription_intervals do
      collection do
        get :search
      end
    end
  end

  resources :subscriptions, :except => [:new]
  resources :subscriptions, :only => [:destroy]

end
