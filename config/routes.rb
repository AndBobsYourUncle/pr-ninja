Rails.application.routes.draw do
  root to: 'pages#home'

  get "/login", to: 'sessions#create', as: :login
  delete '/logout',  to: 'sessions#destroy', as: :logout
end
