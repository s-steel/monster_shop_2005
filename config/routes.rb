Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root 'welcome#index'

  # resources :merchants do
  #   resources :items, only: [:index, :new, :create]
  # end
  resources :merchants
  get '/merchants/:merchant_id/items', to: 'items#index'
  get '/merchants/:merchant_id/items/new', to: 'items#new'
  post '/merchants/:merchant_id/items', to: 'items#create'

  resources :items, except: [:new] do
    resources :reviews, only: [:new, :create]
  end

  resources :reviews, except: [:index, :show, :new, :create]

  post '/cart/:item_id', to: 'cart#add_item'
  patch '/cart/:item_id', to: 'cart#change_amount', as: :cart_update
  get '/cart', to: 'cart#show'
  delete '/cart', to: 'cart#empty'
  delete '/cart/:item_id', to: 'cart#remove_item'

  resources :orders, only: [:new, :create]

  scope :register do
    get '/', to: 'users#new', as: :register
    post '/', to: 'users#create'
  end

  namespace :profile do
    patch '/orders/:id', to: 'orders#update', as: :orders_cancel
  end

  scope :profile do
    get '/orders', to: 'users#orders', as: :profile_orders
    get '/orders/:id', to: 'orders#show', as: :profile_orders_show
    get '', to: 'users#show'
    get '/edit', to: 'users#edit'
    patch '', to: 'users#update', as: :user
    get '/change-password', to: 'users#change_password'
    patch '/change-password', to: 'users#update_password'
  end

  scope :login do
    get '/', to: 'sessions#new', as: :login
    post '/', to: 'sessions#create'
  end

  get '/logout', to: 'sessions#destroy'

  namespace :admin do
    get '/', to: 'dashboard#index'
    patch '/orders/:id', to: 'dashboard#ship'
    resources :users, only: [:index, :show]
    resources :merchants, only: [:show, :index]
    patch '/merchants/:id/disable', to: 'merchants#disable'
    patch '/merchants/:id/enable', to: 'merchants#enable'
  end

  namespace :merchant do
    get '/', to: 'dashboard#show'
    resources :items, execpt: [:show]
    get '/orders/:order_id', to: 'orders#show'
    patch '/orders/:id', to: 'orders#update', as: :order
    patch '/items/:id/deactivate', to: 'items#deactivate'
    patch '/items/:id/activate', to: 'items#activate'
  end
end
