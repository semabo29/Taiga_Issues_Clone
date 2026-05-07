Rails.application.routes.draw do
  # api
  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      resources :issues do
        collection do
          post :bulk
        end
        resource :watching, only: [:show, :create, :destroy]
        resources :comments, only: [:index, :create]
        resources :attachments, only: [:index, :create] 
        resource :deadline, only: [:show, :create, :destroy]
      end
      
      resources :comments, only: [:update, :destroy]
      resources :attachments, only: [:destroy]
      resources :users, only: [:index, :show] 
      
      resources :statuses, except: [:new, :edit]
      resources :priorities, except: [:new, :edit]
      resources :severities, except: [:new, :edit]
      resources :issue_types, except: [:new, :edit]
      resources :tags, except: [:new, :edit]
      resources :deadline_shortcuts, except: [:new, :edit]
    end
  end

  # web
  resources :issues do
    resource :watching, only: [:show, :create, :destroy]
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
end