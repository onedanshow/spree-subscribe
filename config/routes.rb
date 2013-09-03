Spree::Core::Engine.routes.draw do
  namespace :admin do
    resources :subscription_intervals do
      collection do
        get :search
      end
    end
    resources :subscriptions, :except => [:new, :create]
  end


  resources :subscriptions, :only => [:destroy, :create]

end
