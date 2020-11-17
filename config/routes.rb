Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  # root 'welcome#index'
  get '/', to: 'welcome#index', as: :root

    # resources :merchants do
  #   resources :items, only: [:index, :new, :create]
  # end
  resources :merchants
  get '/merchants/:merchant_id/items', to: 'items#index'
  get '/merchants/:merchant_id/items/new', to: 'items#new'
  post '/merchants/:merchant_id/items', to: 'items#create'

  # get '/merchants', to: 'merchants#index'
  # get '/merchants/new', to: 'merchants#new'
  # get '/merchants/:id', to: 'merchants#show'
  # post '/merchants', to: 'merchants#create'
  # get '/merchants/:id/edit', to: 'merchants#edit'
  # patch '/merchants/:id', to: 'merchants#update'
  # delete '/merchants/:id', to: 'merchants#destroy'

  resources :items, except: [:new] do
    resources :reviews, only: [:new, :create]
  end
  # get '/items', to: 'items#index'
  # get '/items/:id', to: 'items#show'
  # get '/items/:id/edit', to: 'items#edit'
  # patch '/items/:id', to: 'items#update'
  # get '/merchants/:merchant_id/items', to: 'items#index'
  # get '/merchants/:merchant_id/items/new', to: 'items#new'
  # post '/merchants/:merchant_id/items', to: 'items#create'
  # delete '/items/:id', to: 'items#destroy'

  get '/items/:item_id/reviews/new', to: 'reviews#new'
  post '/items/:item_id/reviews', to: 'reviews#create'

  get '/reviews/:id/edit', to: 'reviews#edit'
  patch '/reviews/:id', to: 'reviews#update'
  delete '/reviews/:id', to: 'reviews#destroy'

  post '/cart/:item_id', to: 'cart#add_item'
  patch '/cart/:item_id', to: 'cart#change_amount', as: :cart_update
  get '/cart', to: 'cart#show'
  delete '/cart', to: 'cart#empty'
  delete '/cart/:item_id', to: 'cart#remove_item'

  get '/orders/new', to: 'orders#new'
  post '/orders', to: 'orders#create'

  get '/register', to: 'users#new'
  post '/register', to: 'users#create', as: :users
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
