Rails.application.routes.draw do
  scope "(:locale)", locale: /en|vi/ do
    root "static_pages#home"
    devise_for :users, controllers: {
        registrations: "users/registrations",
        sessions: "users/sessions",
        confirmations: "users/confirmations",
        passwords: "users/passwords",
        unlocks: "users/unlocks"
      }
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
