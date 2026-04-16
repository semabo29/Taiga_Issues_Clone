class IssuesController < ApplicationController
  # solo index y show son públicas
  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_issue, only: %i[ show edit update destroy ]
  before_action :authorize_user!, only: [:edit, :update, :destroy]

  def index
    @issues = Issue.all.order(created_at: :desc)
    if params[:query].present?
      search_term = "%#{params[:query]}%"
      @issues = @issues.where("subject LIKE ? OR description LIKE ?", search_term, search_term)
    end

    @issues = @issues.where(issue_type_id: params[:issue_type_id]) if params[:issue_type_id].present?
    @issues = @issues.where(severity_id: params[:severity_id]) if params[:severity_id].present?
    @issues = @issues.where(priority_id: params[:priority_id]) if params[:priority_id].present?
    @issues = @issues.where(status_id: params[:status_id]) if params[:status_id].present?
  end

  def show
  end

  def new
    @issue = Issue.new
  end
  
  def bulk_new
  end

  def bulk_create
    subjects = params[:bulk_issues].to_s.split("\n").map(&:strip).reject(&:blank?)
    
    default_status = Status.find_by(name: "New") || Status.first
    default_priority = Priority.find_by(name: "Normal") || Priority.first
    default_severity = Severity.find_by(name: "Normal") || Severity.first
    default_type = IssueType.find_by(name: "Bug") || IssueType.first

    subjects.each do |subject|
      Issue.create(
        subject: subject,
        status: default_status,
        priority: default_priority,
        severity: default_severity,
        issue_type: default_type,
        user: current_user # Corregido: ahora usa el usuario actual
      )
    end

    redirect_to issues_path, notice: "#{subjects.count} issues were successfully created."
  end

  def edit
  end

  def create
    @issue = Issue.new(issue_params)
    @issue.user = current_user

    if @issue.save
      redirect_to issues_path, notice: "Issue was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @issue.update(issue_params)
      redirect_to issue_url(@issue), notice: "Issue was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @issue.destroy!
    redirect_to issues_path, notice: "Issue was successfully destroyed."
  end

  def purge_attachment
    @attachment = ActiveStorage::Attachment.find(params[:attachment_id])
    @attachment.purge
    redirect_back fallback_location: issues_path, notice: "Attachment was successfully removed."
  end

  private
    def set_issue
      @issue = Issue.find(params[:id])
    end

    def authorize_user!
      unless @issue.user == current_user
        redirect_to issues_path, alert: "You are not allowed."
      end
    end

    def issue_params
      params.require(:issue).permit(:subject, :description, :status_id, :priority_id, :severity_id, :issue_type_id, :deadline, tag_ids: [], attachments: [])
    end
end