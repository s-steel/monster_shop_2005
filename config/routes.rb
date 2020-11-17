Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

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
  
  get '/profile', to: 'users#show'

  get '/profile/orders', to: 'users#orders', as: :profile_orders
  get '/profile/orders/:id', to: 'orders#show', as: :profile_orders_show
  get '/profile/edit', to: 'users#edit', as: :edit
  patch '/profile', to: 'users#update', as: :user

  get '/profile/change-password', to: 'users#change_password'
  patch '/profile/change-password', to: 'users#update_password'
  # Plz refactor inside namespace

  namespace :profile do
    patch '/orders/:id', to: 'orders#update', as: :profile_orders_cancel
  end

  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  get '/logout', to: 'sessions#destroy'


  # Admin
  namespace :admin do
    get '/', to: 'dashboard#index'
    patch '/orders/:id', to: 'dashboard#ship'
    get '/users', to: 'users#index'
    get '/users/:user_id', to: 'users#show', as: :user_show
    get '/merchants/:id', to: 'merchants#show'
    get '/merchants', to: 'merchants#index'
    patch '/merchants/:id/disable', to: 'merchants#disable'
    patch '/merchants/:id/enable', to: 'merchants#enable'
  end

  namespace :merchant do
    get '/', to: 'dashboard#show'
    resources :items, execpt: [:show]
    get '/orders/:order_id', to: 'orders#show'
    patch '/items/:id/deactivate', to: 'items#deactivate'
    patch '/items/:id/activate', to: 'items#activate'
    patch '/orders/:id', to: 'orders#update', as: :order
    get '/items', to: 'items#index'
  end
end
