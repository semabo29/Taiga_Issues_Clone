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

  private
    def set_issue
      @issue = Issue.find(params[:id])
    end

    def issue_params
      params.require(:issue).permit(:subject, :description, :status_id, :priority_id, :severity_id, :issue_type_id, :deadline, tag_ids: [])
    end
end