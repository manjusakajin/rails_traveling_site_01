Rails.application.routes.draw do
  scope "(:locale)", locale: /en|vi/ do
    root "static_pages#home"
    get "/signup", to: "users#new"
    post "/signup", to: "users#create"
    resources :users, only: [:new, :create]
    get "/about", to: "static_pages#about"
  end
end
