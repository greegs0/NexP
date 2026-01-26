Rails.application.routes.draw do
  devise_for :users

  # Root path - Landing page for visitors, dashboard for authenticated users
  authenticated :user do
    root to: "dashboard#show", as: :authenticated_root
  end
  root "landing#index"

  # Dashboard
  get 'dashboard', to: 'dashboard#show', as: :dashboard

  # Feed
  get 'feed', to: 'feed#index', as: :feed

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

  # Posts
  resources :posts do
    resources :comments, only: [:create, :destroy]
    resources :likes, only: [:create]
  end

  # Notifications
  resources :notifications, only: [:index, :update, :destroy] do
    collection do
      get :unread_count
    end
  end

  # Conversations (messages directs)
  resources :conversations, only: [:index, :show] do
    resources :messages, only: [:create], controller: 'conversations', action: :create
  end

  # Bookmarks
  resources :bookmarks, only: [:index, :create, :destroy]

  # User profiles
  resources :users, only: [:show, :index] do
    member do
      get :portfolio
      patch :toggle_availability
      post :follow
      delete :unfollow
    end
  end

  # API Routes
  namespace :api do
    namespace :v1 do
      # Authentication
      post 'auth/login', to: 'auth#login'
      post 'auth/signup', to: 'auth#signup'

      # Users
      resources :users, only: [:index, :show, :update] do
        member do
          post :follow
          delete :unfollow
        end
        collection do
          get :me
        end
      end

      # Projects
      resources :projects do
        member do
          post :join
          delete :leave
        end
      end

      # Posts
      resources :posts do
        member do
          post :like
          delete :unlike
          get :comments
          post :comments, action: :create_comment
        end
        collection do
          get :feed
        end
      end

      # Skills
      resources :skills, only: [:index, :show] do
        collection do
          get :categories
        end
      end

      # Matching
      get 'matching/projects', to: 'matching#projects'
      get 'matching/users', to: 'matching#users'
      get 'matching/similar_users', to: 'matching#similar_users'

      # Analytics
      get 'analytics/platform', to: 'analytics#platform'
      get 'analytics/me', to: 'analytics#me'
      get 'analytics/user/:id', to: 'analytics#user'
      get 'analytics/project/:id', to: 'analytics#project'
      get 'analytics/trending', to: 'analytics#trending'
    end
  end

  # Health check
  get "up" => "rails/health#show", as: :rails_health_check
end
