class PrioritiesController < ApplicationController
  before_action :set_priority, only: %i[ edit update destroy ]

  def index
    @priorities = Priority.all
  end

  def new
    @priority = Priority.new
  end

  def edit; end

  def create
    @priority = Priority.new(priority_params)
    if @priority.save
      redirect_to priorities_path, notice: "Priority was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @priority.update(priority_params)
      redirect_to priorities_path, notice: "Priority was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @priority.destroy!
    redirect_to priorities_path, notice: "Priority was successfully destroyed."
  end

  private
    def set_priority
      @priority = Priority.find(params[:id])
    end

    def priority_params
      params.require(:priority).permit(:name, :color)
    end
end