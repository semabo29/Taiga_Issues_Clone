class UsersController < ApplicationController
  before_action :set_user, only: %i[ show edit update destroy ]

  # GET /users or /users.json
  def index
    @users = User.all
  end

  # GET /users/1 or /users/1.json
  def show
    # Unificamos la pestaña activa (declaramos ambas variables por si tu vista usa una u otra)
    @current_tab = params[:tab] || "assigned"
    @active_tab = @current_tab

    # Lógica de ordenación para la tabla
    sort_column = params[:sort] || "id"
    sort_direction = params[:direction] || "asc"

    order_query = case sort_column
                  when "type"     then "issue_types.name"
                  when "severity" then "severities.name"
                  when "status"   then "statuses.name"
                  when "modified" then "issues.updated_at"
                  else "issues.id"
                  end

    # Cargamos el contenido dependiendo de la pestaña
    if @current_tab == "assigned"
      # Usamos assigned_issues, unimos las tablas para poder ordenar,
      # y EXCLUIMOS las que estén cerradas/finalizadas
      @assigned_issues = @user.assigned_issues
                              .joins(:status, :issue_type, :severity)
                              .where.not(statuses: { name: ['Closed', 'Tancada', 'Finalizada'] })
                              .order("#{order_query} #{sort_direction}")

    elsif @current_tab == "comments"
      @comments = @user.comments.includes(:issue).order(created_at: :desc)
    end

    # Contador de issues abiertas (para el sidebar del perfil)
    @open_issues_count = @user.assigned_issues
                              .joins(:status)
                              .where.not(statuses: { name: ['Closed', 'Tancada', 'Finalizada'] })
                              .count

    respond_to do |format|
      format.html
    end
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users or /users.json
  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        format.html { redirect_to @user, notice: "User was successfully created." }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1 or /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: "User was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1 or /users/1.json
  def destroy
    @user.destroy!

    respond_to do |format|
      format.html { redirect_to users_path, notice: "User was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def user_params
      # ¡Mantenemos :avatar aquí para que siga funcionando la foto de AWS S3!
      params.require(:user).permit(:username, :email, :description, :avatar)
    end
end
