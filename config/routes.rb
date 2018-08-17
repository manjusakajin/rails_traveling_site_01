Rails.application.routes.draw do
  devise_for :users, only: :omniauth_callbacks, controllers: {
      omniauth_callbacks: "users/omniauth_callbacks"
    }
  scope "(:locale)", locale: /en|vi/ do
    root "static_pages#home"
    devise_for :users, skip: :omniauth_callbacks, controllers: {
        registrations: "users/registrations",
        sessions: "users/sessions"
      }
    notify_to :users, with_devise: :users
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
    resources :results, only: [:index]
    resources :plants, only: [:new, :create, :show, :destroy]
    get "hastags/:title", to: "hastags#show", as: :hastag
    mount ActionCable.server => "/cable"
  end
end
