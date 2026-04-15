Rails.application.routes.draw do
  # El núcleo de la aplicación
  resources :issues do
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
  # Apartado de Settings
  scope :settings do
    get "/" => "settings#index", as: :settings # Ruta base de settings
    resources :statuses
    resources :priorities
    resources :severities
    resources :issue_types
    resources :tags
  end

  # Health check y Root
  get "up" => "rails/health#show", as: :rails_health_check
  root "issues#index"
end