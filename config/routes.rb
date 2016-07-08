Myflix::Application.routes.draw do
  get 'ui(/:action)', controller: 'ui'

  root to: "pages#front"
  resources :videos, only: [:show] do
    collection do
      post :search, to: "videos#search"
    end
  end
  resources :categories, only: [:show]

  get "register", to: "users#new"
  get "sign_in", to: "sessions#new"
  get "sign_out", to: "sessions#destroy"
  get "home", to: "videos#index"

  resources :users, only: [:create]
  resources :sessions, only: [:create]
end