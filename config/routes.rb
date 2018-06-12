Rails.application.routes.draw do
  get 'microposts/index'

  root 'static_pages#home'
  get "contacts/new"
  get "users/show"
  match '/help',    to: 'static_pages#help',    via: 'get'
  match '/about',   to: 'static_pages#about',   via: 'get'
  match '/contact', to: 'static_pages#contact', via: 'get'
  devise_for :users, controllers: {
    :registrations => "registrations",
    :omniauth_callbacks => "omniauth_callbacks"
  }
  resources :users, only: [:show, :index, :destroy] do
    member do
      get :following, :followers
    end
  end
  resources :microposts do
    member do
      get :reposting
    end
  end
  resources :likes, only: [:create, :destroy]

  resources :hashtags, only: [:create, :destroy]
  resources :relationships, only: [:create, :destroy]
  resources :contacts, only: [:new, :create]
end
