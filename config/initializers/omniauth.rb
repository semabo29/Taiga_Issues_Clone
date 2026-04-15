#Archivo para hacer la autentificacion con google
Rails.application.config.middleware.use OmniAuth::Builder do
  provider :google_oauth2, ENV['GOOGLE_CLIENT_ID'], ENV['GOOGLE_CLIENT_SECRET']
end

#Esto permite que el botón de login funcione correctamente en Rails 7
OmniAuth.config.allowed_request_methods = %i[get post]