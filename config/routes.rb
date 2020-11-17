Rails.application.routes.draw do

  get '/', to: 'welcome#index', as: :root
  # root 'welcome#index'

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

  scope :profile do
    get '/', to: 'users#show'

    scope :orders do
      get '/', to: 'users#orders', as: :profile_orders
      get '/:id', to: 'orders#show', as: :profile_orders_show
    end

    get '/edit', to: 'users#edit', as: :edit
    patch '/', to: 'users#update', as: :user
    get '/change-password', to: 'users#change_password'
    patch '/change-password', to: 'users#update_password'
  end

  # namespace :profile do
  #   patch '/orders/:id', to: 'orders#update', as: :profile_orders_cancel
  # end
  patch '/profile/orders/:id', to: 'profile/orders#update', as: :profile_orders_cancel

  scope :login do
    get '/', to: 'sessions#new', as: :login
    post '/', to: 'sessions#create'
  end

  scope :logout do
    get '/', to: 'sessions#destroy', as: :logout
  end

  namespace :admin do
    # get '/', to: 'dashboard#index'
    # patch '/orders/:id', to: 'dashboard#ship'
    resources :users, only: [:index, :show]
    resources :merchants, only: [:show, :index]
    # patch '/merchants/:id/disable', to: 'merchants#disable'
    # patch '/merchants/:id/enable', to: 'merchants#enable'
  end
  get '/admin', to: 'admin/dashboard#index'
  patch '/admin/orders/:id', to: 'admin/dashboard#ship'
  patch '/admin/merchants/:id/disable', to: 'admin/merchants#disable'
  patch '/admin/merchants/:id/enable', to: 'admin/merchants#enable'


  namespace :merchant do
    # get '/', to: 'dashboard#show'
    resources :items, except: [:show]
    # get '/orders/:order_id', to: 'orders#show'
    # patch '/items/:id/deactivate', to: 'items#deactivate'
    # patch '/items/:id/activate', to: 'items#activate'
    # patch '/orders/:id', to: 'orders#update', as: :order
    resources :items, only: [:index]
    # get '/items', to: 'items#index'
  end
  get '/merchant', to: 'merchant/dashboard#show'
  get '/merchant/orders/:order_id', to: 'merchant/orders#show'
  patch '/merchant/items/:id/deactivate', to: 'merchant/items#deactivate'
  patch '/merchant/items/:id/activate', to: 'merchant/items#activate'
  patch '/merchant/orders/:id', to: 'merchant/orders#update', as: :merchant_order
end
