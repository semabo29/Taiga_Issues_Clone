class SeveritiesController < ApplicationController
  before_action :set_severity, only: %i[ edit update destroy ]

  def index
    @severities = Severity.all
  end

  def new
    @severity = Severity.new
  end

  def edit; end

  def create
    @severity = Severity.new(severity_params)
    if @severity.save
      redirect_to severities_path, notice: "Severity was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @severity.update(severity_params)
      redirect_to severities_path, notice: "Severity was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @severity.destroy!
    redirect_to severities_path, notice: "Severity was successfully destroyed."
  end

  private
    def set_severity
      @severity = Severity.find(params[:id])
    end

    def severity_params
      params.require(:severity).permit(:name, :color)
    end
end