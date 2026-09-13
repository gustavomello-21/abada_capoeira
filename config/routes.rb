Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: "users/registrations" }

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  root "home#index"

  # Feature 1 — Encontre uma Abada (público)
  resources :points, only: [ :index, :show ]
  get "geocode/search", to: "geocode#search"

  # Feature 2 — Eventos (aluno autenticado)
  resources :events, only: [ :index, :show ] do
    resources :registrations, only: [ :new, :create ], shallow: true
  end

  namespace :admin do
    root "dashboard#index"
    resources :points, except: [ :show ]
    resources :events do
      resources :registrations, only: [ :index, :show ] do
        member do
          patch :approve
          patch :reject
        end
      end
    end
  end
end
