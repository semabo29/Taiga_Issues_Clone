class Issue < ApplicationRecord
  belongs_to :user
  belongs_to :status
  belongs_to :priority
  belongs_to :severity
  belongs_to :issue_type
  has_many_attached :attachments

  validates :subject, presence: true
end