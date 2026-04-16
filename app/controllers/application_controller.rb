class ApplicationController < ActionController::Base
    helper_method :current_user

  def current_user
    #Si hay una sesión, buscamos al usuario. El ||= es para no buscarlo 2 veces.
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
  end

  #Método para redirigir si no están logueados
  def authenticate_user!
    redirect_to root_path, alert: "Debes iniciar sesión" unless current_user
  end
end
