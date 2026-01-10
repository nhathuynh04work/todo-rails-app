Rails.application.routes.draw do
  resources :tasks

  get "/signup", to: "registrations#new", as: :signup
  post "/signup", to: "registrations#create"

  get "/login", to: "sessions#new", as: :login
  post "/login", to: "sessions#create"

  resources :dashboard, only: [ :show ]
  root "static_pages#home"
end
