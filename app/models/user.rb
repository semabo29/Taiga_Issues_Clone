class User < ApplicationRecord
  # Relacions
  has_many :issues, dependent: :destroy # Issues creades per l'usuari
  has_many :comments, dependent: :destroy
  has_many :assigned_issues, class_name: "Issue", foreign_key: "assigned_to_id"
  
  has_many :watchings, dependent: :destroy
  has_many :watched_issues, through: :watchings, source: :issue
  
  has_one_attached :avatar


  before_save :ensure_api_key

  def self.from_omniauth(auth)
    user = where(email: auth.info.email).first_or_initialize do |u|
      u.username = auth.info.name || auth.info.email.split('@').first
    end

    user.ensure_api_key 
    user.save
    user
  end
  
  def ensure_api_key
    if self.api_key.blank?
      self.api_key = SecureRandom.hex(16)
    end
  end
end