Rails.application.routes.draw do
  root to: 'pages#home'

  get "/completed", to: 'pages#completed', as: :completed

  get "/login", to: 'sessions#create', as: :login
  delete '/logout',  to: 'sessions#destroy', as: :logout

  resources :user_tags, only: [] do
    member do
      put :mark_complete
      put :mark_active
      post :move
    end
  end
end
