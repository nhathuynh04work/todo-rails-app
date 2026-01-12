Rails.application.routes.draw do
  resources :projects, only: [ :new, :create, :show ]
  resources :tasks, only: [ :new, :create ] do
    member do
      post :toggle
    end
  end

  get "/signup", to: "registrations#new", as: :signup
  post "/signup", to: "registrations#create"

  get "/login", to: "sessions#new", as: :login
  post "/login", to: "sessions#create"

  delete "/logout", to: "sessions#destroy", as: :logout

  resource :dashboard, only: [ :show ]
  root "static_pages#home"
end
