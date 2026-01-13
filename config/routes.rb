Rails.application.routes.draw do
  devise_for :users

  # Root path
  root "dashboard#show"

  # Dashboard
  get 'dashboard', to: 'dashboard#show', as: :dashboard

  # Skills management
  resources :skills, only: [:index, :show]
  resources :user_skills, only: [:create, :destroy]

  # Projects
  resources :projects do
    member do
      post :join
      delete :leave
    end
    resources :messages, only: [:index, :create]
  end

  # User profiles
  resources :users, only: [:show] do
    member do
      get :portfolio
    end
  end

  # Health check
  get "up" => "rails/health#show", as: :rails_health_check
end
