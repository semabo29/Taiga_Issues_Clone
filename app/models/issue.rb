class Issue < ApplicationRecord
  belongs_to :user, optional: true # Mientras no haya login
  belongs_to :status
  belongs_to :priority
  belongs_to :severity
  belongs_to :issue_type
  belongs_to :assigned_to, class_name: 'User', optional: true
  alias_attribute :deadline, :due_date
  has_many_attached :attachments

  has_many :issue_tags, dependent: :destroy
  has_many :tags, through: :issue_tags
  has_many :comments, dependent: :destroy
  has_many :watchings, dependent: :destroy
  has_many :watchers, through: :watchings, source: :user
  has_many :activities, dependent: :destroy


  validates :subject, presence: true
  after_create :log_creation

  after_update :log_changes

  private

  def log_creation
    Activity.create(
      user: self.user, 
      issue: self, 
      change_details: "created the issue"
    )
  end

  def log_changes
  # Obtenemos los cambios ignorando las fechas automáticas
  changes = saved_changes.except(:updated_at, :created_at)
  return if changes.empty?

  details = []
  
  changes.each do |field, values|
    old_val, new_val = values
    
    case field
    when 'status_id'
      label = "status"
      old_text = Status.find_by(id: old_val)&.name || "not set"
      new_text = Status.find_by(id: new_val)&.name || "not set"
      details << "<span class='activity-label-badge'>#{label}</span> #{old_text} <span class='activity-arrow'>›</span> #{new_text}"

    when 'priority_id'
      label = "priority"
      old_text = Priority.find_by(id: old_val)&.name || "not set"
      new_text = Priority.find_by(id: new_val)&.name || "not set"
      details << "<span class='activity-label-badge'>#{label}</span> #{old_text} <span class='activity-arrow'>›</span> #{new_text}"

    when 'severity_id' 
      label = "severity"
      old_text = Severity.find_by(id: old_val)&.name || "not set"
      new_text = Severity.find_by(id: new_val)&.name || "not set"
      details << "<span class='activity-label-badge'>#{label}</span> #{old_text} <span class='activity-arrow'>›</span> #{new_text}"

    when 'issue_type_id' 
      label = "type"
      old_text = IssueType.find_by(id: old_val)&.name || "not set"
      new_text = IssueType.find_by(id: new_val)&.name || "not set"
      details << "<span class='activity-label-badge'>#{label}</span> #{old_text} <span class='activity-arrow'>›</span> #{new_text}"

    when 'assigned_to_id'
      label = "assigned to"
      old_text = User.find_by(id: old_val)&.username || "unassigned"
      new_text = User.find_by(id: new_val)&.username || "unassigned"
      details << "<span class='activity-label-badge'>#{label}</span> #{old_text} <span class='activity-arrow'>›</span> #{new_text}"

    when 'deadline'
      label = "due date"
      old_t = old_val.present? ? old_val.strftime("%d %b %Y") : "not set"
      new_t = new_val.present? ? new_val.strftime("%d %b %Y") : "not set"
      details << "<span class='activity-label-badge'>#{label}</span> #{old_t} <span class='activity-arrow'>›</span> #{new_t}"

    when 'subject'
      label = "subject"
      details << "<span class='activity-label-badge'>#{label}</span> renamed from <i>#{old_val}</i>"
    end
  end

  if details.any?
    Activity.create!(
      user_id: self.user_id,
      issue: self,
      action: "updated",
      change_details: details.join("<br>") 
    )
  end
end
end