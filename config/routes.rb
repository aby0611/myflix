Myflix::Application.routes.draw do
  get 'ui(/:action)', controller: 'ui'

  get 'home', to: 'video#index'
  resources :videos, only: [:show]
end

