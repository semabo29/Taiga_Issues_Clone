class IssuesController < ApplicationController
  before_action :set_issue, only: %i[ show edit update destroy ]

  # GET /issues
  def index
    # ordenat de nou a antic
    @issues = Issue.all.order(created_at: :desc)
  end

  # GET /issues/1
  def show
  end

  # GET /issues/new
  def new
    @issue = Issue.new
  end

  # GET /issues/1/edit
  def edit
  end

  # POST /issues
  def create
    @issue = Issue.new(issue_params)

    # la issue s'assigna al current_user automaticament
    @issue.user = current_user

    # valors predefinits pq encara no s'ha d'implementar
    @issue.status = "New"
    @issue.priority = "Normal"
    @issue.severity = "Normal"

    if @issue.save
      # redirigeix a la llista de issues
      redirect_to issues_path, notice: "Issue was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /issues/1
  def update
    if @issue.update(issue_params)
      redirect_to @issue, notice: "Issue was successfully updated.", status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /issues/1
  def destroy
    @issue.destroy!
    redirect_to issues_path, notice: "Issue was successfully destroyed.", status: :see_other
  end

  private
    def set_issue
      @issue = Issue.find(params[:id])
    end

    # MODIFICACIÓ: Només permetem :subject i :description
    # Segons l'enunciat: "just providing a Subject and a Description"
    def issue_params
      params.require(:issue).permit(:subject, :description)
    end
end