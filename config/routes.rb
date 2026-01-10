Rails.application.routes.draw do
  resources :tasks

  get "/signup", to: "registrations#new", as: :signup
  post "/signup", to: "registrations#create"

  get "/login", to: "sessions#new", as: :login

  root "static_pages#home"
end
