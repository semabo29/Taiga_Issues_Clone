Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins '*'

    # Aplicamos esta regla a todas las rutas (puedes restringirlo a '/api/*' si prefieres)
    resource '/api/*',
      headers: :any,
      
      # Nivell 2
      methods: [:get, :post, :put, :patch, :delete, :options, :head]
  end
end