Rails.application.routes.draw do
  scope "(:locale)", locale: /en|vi/ do
    root "static_pages#home"
    get "/signup", to: "users#new"
    post "/signup", to: "users#create"
    get "/login", to: "sessions#new"
    post "/login", to: "sessions#create"
    delete "/logout", to: "sessions#destroy"
    resources :users
    resources :trips, only: [:new, :create, :index, :show, :destroy] do
      resources :participations, only: [:create, :destroy, :index]
    end
    namespace :owner do
      resources :trips, only: [:update, :edit] do
        resources :participations,
          only: [:index, :create, :update, :destroy]
        resources :searchs, only: :index
      end
    end
    resources :reviews do
      resources :comments
    end
    resources :comments do
      resources :comments
    end
    get "/about", to: "static_pages#about"
    resources :chatrooms, param: :slug
    resources :messages
    resources :reviews
    get "hastags/:title", to: "hastags#show", as: :hastag
    mount ActionCable.server => "/cable"
    mount Ckeditor::Engine => "/ckeditor"
  end
end
