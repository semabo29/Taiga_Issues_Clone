class SessionsController < ApplicationController
  def create
    #Recibimos la info de Google
    auth = request.env['omniauth.auth']

    #Buscamos/Creamos al usuario en nuestra DB usando el email y el resto de la info
    user = User.from_omniauth(auth)

    #Guardamos el ID interno en la DB (el 1, 2, 3...)
    session[:user_id] = user.id

    redirect_to root_path, notice: "¡Bienvenido, #{user.username}!"
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_path, notice: "Sesión cerrada."
  end
end