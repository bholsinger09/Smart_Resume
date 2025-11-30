Rails.application.routes.draw do
  root 'home#index'
  
  resources :jobs do
    member do
      post :match_resume
    end
  end
  
  resources :resumes, only: [:index, :create, :show, :destroy] do
    member do
      get :analysis
    end
  end
  
  resources :matches, only: [:index, :show, :create]
  
  # PWA routes
  get '/manifest.json', to: 'pwa#manifest', defaults: { format: :json }
  get '/service-worker.js', to: 'pwa#service_worker', defaults: { format: :js }
  get '/offline', to: 'pwa#offline'
  
  # API routes
  namespace :api do
    namespace :v1 do
      resources :jobs, only: [:index, :show]
      resources :resumes, only: [:create, :show]
      post '/match', to: 'matches#create'
    end
  end
  
  # Health check
  get '/health', to: 'application#health'
end
