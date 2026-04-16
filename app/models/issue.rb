class Issue < ApplicationRecord
  belongs_to :user, optional: true # Mientras no haya login
  belongs_to :status
  belongs_to :priority
  belongs_to :severity
  belongs_to :issue_type
  belongs_to :assigned_to, class_name: 'User', optional: true

  has_many_attached :attachments

  has_many :issue_tags, dependent: :destroy
  has_many :tags, through: :issue_tags
  has_many :comments, dependent: :destroy

  validates :subject, presence: true
end