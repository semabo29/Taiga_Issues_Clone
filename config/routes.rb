Rails.application.routes.draw do
  # El núcleo de la aplicación
  resources :issues do
    resource :watching, only: [:create, :destroy] 

    resources :comments, only: [:create, :edit, :update, :destroy]

    # Definim rutes a nivell de col·lecció (no requereixen un ID d'issue previ)
    collection do
      get 'bulk_new'
      post 'bulk_create'

    end
    
    # Definim rutes a nivell de membre (per a una issue específica)
    member do
      delete :purge_attachment
    end
  end
  
  resources :users # Más adelante gestionaremos el perfil aquí

  # Apartado de Settings (Agrupado para el Lliurament)
  # Esto hará que las URLs sean /settings/statuses, /settings/priorities...
  scope :settings do
    get "/" => "settings#index", as: :settings # Ruta base de settings
    resources :statuses
    resources :priorities
    resources :severities
    resources :issue_types
    resources :tags
    resources :deadline_shortcuts 
  end

  # Rutas de login del usuario
  get '/auth/:provider/callback', to: 'sessions#create'
  get '/auth/failure', to: redirect('/')
  delete '/logout', to: 'sessions#destroy', as: :logout

  # Health check y Root
  get "up" => "rails/health#show", as: :rails_health_check
  root "issues#index"
end