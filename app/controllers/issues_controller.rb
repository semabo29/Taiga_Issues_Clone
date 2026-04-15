class IssuesController < ApplicationController
  before_action :set_issue, only: %i[ show edit update destroy ]

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

  private
    def set_issue
      @issue = Issue.find(params[:id])
    end

    def issue_params
      params.require(:issue).permit(:subject, :description, :status_id, :priority_id, :severity_id, :issue_type_id, :deadline, tag_ids: [])
    end
end