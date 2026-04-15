class User < ApplicationRecord
  #No tocamos el id, Rails lo gestiona solo.
  #Usamos el email para identificar al usuario de Google.
  def self.from_omniauth(auth)
    #Buscamos por la columna email de la tabla
    where(email: auth.info.email).first_or_create do |user|
      #Si no existe, creamos el usuario con los datos de Google
      user.username = auth.info.name || auth.info.email.split('@').first
    end
  end
end