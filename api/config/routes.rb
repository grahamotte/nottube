Rails.application.routes.draw do
  resources :subscriptions do
    collection do
      post :sync_all
    end
    member do
      post :sync
    end
  end

  resources :videos

  resources :jobs do
    collection do
      post :destroy_all
    end
  end

  resources :settings, only: [:index] do
    collection do
      post :update
    end
  end

  mount ActionCable.server => '/cable'
end
