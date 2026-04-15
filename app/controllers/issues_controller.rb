class IssuesController < ApplicationController
  before_action :set_issue, only: %i[ show edit update destroy ]

  def index
    @issues = Issue.all.order(created_at: :desc)
  end

  def show
  end

  def new
    @issue = Issue.new
  end
  
  def bulk_new
  end

  def bulk_create
    # Separem el text d'entrada per salts de línia i eliminem línies buides
    subjects = params[:bulk_issues].to_s.split("\n").map(&:strip).reject(&:blank?)
    
    # Obtenim els valors per defecte. Si no existeixen, agafem el primer registre disponible
    default_status = Status.find_by(name: "New") || Status.first
    default_priority = Priority.find_by(name: "Normal") || Priority.first
    default_severity = Severity.find_by(name: "Normal") || Severity.first
    default_type = IssueType.find_by(name: "Bug") || IssueType.first
    current_user = User.first

    # Creem una issue per cada línia extreta del textarea
    subjects.each do |subject|
      Issue.create(
        subject: subject,
        status: default_status,
        priority: default_priority,
        severity: default_severity,
        issue_type: default_type,
        user: current_user
      )
    end

    redirect_to issues_path, notice: "#{subjects.count} issues were successfully created."
  end

  def edit
  end

  def create
    @issue = Issue.new(issue_params)
    @issue.user = User.first # Hardcoded para la Sesión 02 hasta tener Login

    if @issue.save
      redirect_to issues_path, notice: "Issue was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    respond_to do |format|
      if @issue.update(issue_params)
        # Importante: redirigir a @issue (el show) para salir del modo edición
        format.html { redirect_to issue_url(@issue), notice: "Issue was successfully updated." }
      else
        # Si hay error (ej: falta el subject), se queda en edit
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @issue.destroy!
    redirect_to issues_path, notice: "Issue was successfully destroyed."
  end

  # Mètode per esborrar un adjunt específic
  def purge_attachment
    @attachment = ActiveStorage::Attachment.find(params[:attachment_id])
    @attachment.purge
    redirect_back fallback_location: issues_path, notice: "Attachment was successfully removed."
  end

  private
    def set_issue
      @issue = Issue.find(params[:id])
    end

    def issue_params
      # Permetem rebre un array d'adjunts
      params.require(:issue).permit(:subject, :description, :status_id, :priority_id, :severity_id, :issue_type_id, :deadline, attachments: [])
    end
end