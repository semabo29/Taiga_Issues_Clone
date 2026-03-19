json.extract! issue, :id, :subject, :description, :status, :priority, :severity, :user_id, :created_at, :updated_at
json.url issue_url(issue, format: :json)
