Rails.application.routes.draw do
  root to: "toppages#index"
  get "register", to: "users#new"
  resources :users, except: :index
  get "users/:id/delete", to: "users#delete", as: "delete"
  get "complete", to: "users#complete"
end
