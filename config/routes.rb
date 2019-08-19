Rails.application.routes.draw do
  root to: 'pages#home'

  get "/login", to: 'sessions#create', as: :login
  delete '/logout',  to: 'sessions#destroy', as: :logout

  resources :pull_requests_tagged_users, only: [] do
    member do
      put 'mark_completed'
    end
  end
end
