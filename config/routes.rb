Rails.application.routes.draw do
  devise_for :admin_users
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  root to: "toppages#index"
  get "detail", to: "toppages#detail"
  
  get "register", to: "users#new"
  resources :users, except: :index do
    member do
      get :followings
      get :followers
      get :likes
    end
  end
  
  get "users/:id/delete", to: "users#delete", as: "delete"
  get "complete", to: "users#complete"
  
  get "login", to: "sessions#new"
  post "login", to: "sessions#create"
  delete "logout", to: "sessions#destroy"
  
  resources :posts, except: :index do
    collection do
      get :new
      get :search
      get :slow
      get :fast
      get :spring
      get :summer
      get :autumn
      get :winter
    end
  end
  
  # 投稿の詳細検索画面
  get "search_for", to: "posts#search_for"
  
  resources :relationships, only: [:create, :destroy] 
  resources :post_comments, only: [:create, :edit, :update, :destroy]
  resources :prefectures, only: [:show]
  resources :favorites, only: [:create, :destroy]
end
