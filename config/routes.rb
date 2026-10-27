Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  root "pages#home"

  resources :customers
  resources :bikes
  resources :repairs
  resources :services
  resources :staff_members

  get "visit", to: "pages#visit", as: :visit
  get "about", to: "pages#about", as: :about

  # Lab 10 — JSON API
  namespace :api do
    namespace :v1 do
      resources :services, only: [:index, :show, :create]
      resources :repairs, only: [:index, :show]
    end
  end
end