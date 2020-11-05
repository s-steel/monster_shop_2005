Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root 'welcome#index'

  resources :merchants

  resources :items, except: [:new]
  
  get '/merchants/:merchant_id/items', to: 'items#index'
  get '/merchants/:merchant_id/items/new', to: 'items#new'
  post '/merchants/:merchant_id/items', to: 'items#create'

  get '/items/:item_id/reviews/new', to: 'reviews#new'
  post '/items/:item_id/reviews', to: 'reviews#create'

  resources :reviews, except: [:index, :show, :new, :create]

  post '/cart/:item_id', to: 'cart#add_item'
  patch '/cart/:item_id', to: 'cart#change_amount', as: :cart_update
  get '/cart', to: 'cart#show'
  delete '/cart', to: 'cart#empty'
  delete '/cart/:item_id', to: 'cart#remove_item'

  resources :orders, only: [:new, :create]

  get '/register', to: 'users#new'
  post '/register', to: 'users#create'

  namespace :profile do
    patch '/orders/:id', to: 'orders#update', as: :profile_orders_cancel
  end
  get '/profile/orders', to: 'users#orders', as: :profile_orders
  get '/profile/orders/:id', to: 'orders#show', as: :profile_orders_show
  get '/profile', to: 'users#show'
  get '/profile/edit', to: 'users#edit'
  patch '/profile', to: 'users#update', as: :user
  get '/profile/change-password', to: 'users#change_password'
  patch '/profile/change-password', to: 'users#update_password'

  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
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
