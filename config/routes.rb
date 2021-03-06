Myflix::Application.routes.draw do
  get 'ui(/:action)', controller: 'ui'

  root to: "pages#front"

  resources :videos, only: [:show] do
    collection do
      post :search, to: "videos#search"
      get 'advanced_search', to: "videos#advanced_search", as: :advanced_search
    end
    resources :reviews, only: [:create]
  end

  namespace :admin do
    resources :videos, only: [:new, :create]
    resources :payments, only: [:index]
  end

  resources :categories, only: [:show]
  resources :users, only: [:show]
  resources :queue_items, only: [:create, :destroy]
  post "update_queue", to: "queue_items#update_queue"

  get "register", to: "users#new"
  get "register/:token", to: "users#new_with_invitation_token", as: "register_with_token"
  get "sign_in", to: "sessions#new"
  get "sign_out", to: "sessions#destroy"
  get "home", to: "videos#index"
  get "my_queue", to: "queue_items#index"
  get "people", to: "relationships#index"

  resources :users, only: [:create]
  resources :sessions, only: [:create]
  resources :relationships, only: [:create, :destroy]

  get "forgot_password", to: "forgot_passwords#new"
  resources :forgot_passwords, only: [:create]
  get "forgot_password_confirmation", to: "forgot_passwords#confirm"

  resources :password_resets, only: [:show, :create]
  get "expired_token", to: "pages#expired_token"

  resources :invitations, only: [:new, :create]

  mount StripeEvent::Engine, at: '/stripe_events'
end