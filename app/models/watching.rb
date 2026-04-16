class Watching < ApplicationRecord
  belongs_to :user
  belongs_to :issue
  validates :user_id, uniqueness: { scope: :issue_id }

end
