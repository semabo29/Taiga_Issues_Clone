class IssuesController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_issue, only: %i[ show edit update destroy ]
  before_action :authorize_user!, only: [:edit, :update, :destroy]


  def index
    # Partimos de todas las issues ordenadas de más nuevas a más antiguas
    @issues = Issue.all.order(created_at: :desc)

    # 1. Cerca por texto (Subject o Description)
    if params[:query].present?
      # Usamos LIKE para buscar si el texto contiene la palabra clave
      search_term = "%#{params[:query]}%"
      @issues = @issues.where("subject LIKE ? OR description LIKE ?", search_term, search_term)
    end

    # 2. Filtros "include" (Desplegables)
    if params[:issue_type_id].present?
      @issues = @issues.where(issue_type_id: params[:issue_type_id])
    end

    if params[:severity_id].present?
      @issues = @issues.where(severity_id: params[:severity_id])
    end
    
    if params[:priority_id].present?
      @issues = @issues.where(priority_id: params[:priority_id])
    end

    if params[:status_id].present?
      @issues = @issues.where(status_id: params[:status_id])
    end
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
    @issue.user = current_user #Usa el usuario logeado

    if @issue.save
      redirect_to issues_path, notice: "Issue was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @issue.update(issue_params)
      # Importante: redirigir a @issue (el show) para salir del modo edición
      redirect_to issue_url(@issue), notice: "Issue was successfully updated."
    else
      # Si hay error (ej: falta el subject), se queda en edit
      render :edit, status: :unprocessable_entity
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
    def authorize_user!
      unless @issue.user == current_user
        redirect_to issues_path, alert: "You are not allowed."
      end
    end
    def issue_params
      params.require(:issue).permit(:subject, :description, :status_id, :priority_id, :severity_id, :issue_type_id, :deadline, tag_ids: [], attachments: [])
    end
end