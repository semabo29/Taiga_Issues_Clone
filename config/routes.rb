Rails.application.routes.draw do
  # === Rutes web ===
  
  resources :issues do
    resource :watching, only: [:create, :destroy] 
    resources :comments, only: [:create, :edit, :update, :destroy]

    collection do
      get 'bulk_new'
      post 'bulk_create'
    end
    
    member do
      delete :purge_attachment
    end
  end
  
  resources :users

  scope :settings do
    get "/" => "settings#index", as: :settings
    resources :statuses
    resources :priorities
    resources :severities
    resources :issue_types
    resources :tags
    resources :deadline_shortcuts 
  end

  get '/auth/:provider/callback', to: 'sessions#create'
  get '/auth/failure', to: redirect('/')
  delete '/logout', to: 'sessions#destroy', as: :logout

  get "up" => "rails/health#show", as: :rails_health_check
  root "issues#index"


  # === API REST ===
  # Namespace que agrupa las rutas bajo /api y espera les respostes en JSON
  namespace :api, defaults: { format: :json } do
    # v1
    namespace :v1 do
      resources :issues do
        resources :comments, only: [:create, :update, :destroy]
      end
      resources :users, only: [:index, :show] 
      resources :statuses
      resources :priorities
      resources :severities
      resources :issue_types
      resources :tags
    end
  end
end