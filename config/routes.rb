Myflix::Application.routes.draw do
  get 'ui(/:action)', controller: 'ui'

  root to: "pages#front"
  resources :videos, only: [:show] do
    collection do
      post :search, to: "videos#search"
    end
    resources :reviews, only: [:create]
  end
  resources :categories, only: [:show]
  resources :users, only: [:show]
  resources :queue_items, only: [:create, :destroy]
  post "update_queue", to: "queue_items#update_queue"

  get "register", to: "users#new"
  get "sign_in", to: "sessions#new"
  get "sign_out", to: "sessions#destroy"
  get "home", to: "videos#index"
  get "my_queue", to: "queue_items#index"
  get "people", to: "relationships#index"

  resources :users, only: [:create]
  resources :sessions, only: [:create]
  resources :relationships, only: [:destroy]
end