class DeadlineShortcutsController < ApplicationController
  before_action :set_deadline_shortcut, only: %i[ show edit update destroy ]

  # GET /deadline_shortcuts or /deadline_shortcuts.json
  def index
    @deadline_shortcuts = DeadlineShortcut.all
  end

  # GET /deadline_shortcuts/1 or /deadline_shortcuts/1.json
  def show
  end

  # GET /deadline_shortcuts/new
  def new
    @deadline_shortcut = DeadlineShortcut.new
  end

  # GET /deadline_shortcuts/1/edit
  def edit
  end

  def create
    @deadline_shortcut = DeadlineShortcut.new(deadline_shortcut_params)

    if @deadline_shortcut.save
      redirect_to deadline_shortcuts_path, notice: "Deadline shortcut was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @deadline_shortcut.update(deadline_shortcut_params)
      redirect_to deadline_shortcuts_path, notice: "Deadline shortcut was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /deadline_shortcuts/1 or /deadline_shortcuts/1.json
  def destroy
    @deadline_shortcut.destroy!

    respond_to do |format|
      format.html { redirect_to deadline_shortcuts_path, notice: "Deadline shortcut was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_deadline_shortcut
      @deadline_shortcut = DeadlineShortcut.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def deadline_shortcut_params
      params.require(:deadline_shortcut).permit(:name, :offset_days)
    end
end
