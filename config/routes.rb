Rails.application.routes.draw do
  resources :tasks

  get "/signup", to: "auth#signup", as: :signup
  post "/signup", to: "auth#register_user"
  get "/login", to: "auth#login", as: :login

  root "static_pages#home"
end
