class User < ApplicationRecord
  #No tocamos el id, Rails lo gestiona solo.
  #Usamos el email para identificar al usuario de Google.
  has_many :issues, dependent: :destroy #issues assignadas al usuario
  has_many :comments, dependent: :destroy
  has_many :assigned_issues, class_name: "Issue", foreign_key: "assigned_to_id"
  has_many :issues, dependent: :destroy
  has_many :watchings, dependent: :destroy
  has_many :watched_issues, through: :watchings, source: :issue
  has_one_attached :avatar
  before_create :generate_api_key

  def self.from_omniauth(auth)
    #Buscamos por la columna email de la tabla
    where(email: auth.info.email).first_or_create do |user|
      #Si no existe, creamos el usuario con los datos de Google
      user.username = auth.info.name || auth.info.email.split('@').first
    end
  end
  
  def generate_api_key
    # Genera una cadena aleatòria única de 32 caràcters
    self.api_key = SecureRandom.hex(16) if self.api_key.blank?
  end
end