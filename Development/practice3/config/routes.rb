Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  devise_for :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  root "items#index"

  resources :items do
    member do
      get :toggle
      get :add
    end
  end

  resources :orders
  resources :user_items
end
