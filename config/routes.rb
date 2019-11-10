Rails.application.routes.draw do
  root to: "toppages#index"
  get "register", to: "users#new"
  resources :users, except: :index do
    member do
      get :followings
      get :followers
    end
  end
  
  get "users/:id/delete", to: "users#delete", as: "delete"
  get "complete", to: "users#complete"
  
  get "login", to: "sessions#new"
  post "login", to: "sessions#create"
  delete "logout", to: "sessions#destroy"
  
  resources :posts, except: :index
  
  resources :relationships, only: [:create, :destroy] 
  
  resources :post_comments, only: [:create, :edit, :update, :destroy]
  
  resources :prefectures, only: [:show]
end
