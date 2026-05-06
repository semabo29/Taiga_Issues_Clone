module Api
  module V1
    class UsersController < Api::BaseController
      # Cargamos el usuario de la URL para los métodos GET
      before_action :set_user, only: %i[show assigned_issues watched_issues]

      # GET /api/v1/users/:id
      def show
        render json: user_json(@user)
      end

      # GET /api/v1/users/:id/assigned_issues
      def assigned_issues
        # Ordenación: por defecto ordena por created_at de forma descendente
        sort_column = params[:sort] || 'created_at'
        sort_direction = %w[asc desc].include?(params[:direction]&.downcase) ? params[:direction] : 'desc'

        # Validación básica para evitar inyecciones SQL en el order
        safe_columns = %w[created_at updated_at status_id priority_id subject]
        sort_column = 'created_at' unless safe_columns.include?(sort_column)

        issues = @user.assigned_issues
          .joins(:status)
          .where.not(statuses: { name: ['Closed', 'Tancada', 'Finalizada'] })
          .order("#{sort_column} #{sort_direction}")
        render json: issues
      end

      # GET /api/v1/users/:id/watched_issues
      def watched_issues
        # Comprobamos que el usuario consultado sea el mismo que el del token
        if @user != @current_user
          render json: { error: "No tens permís per veure les incidències observades d'un altre usuari" }, status: :forbidden
          return
        end

        render json: @user.watched_issues.order(created_at: :desc)
      end

      # PATCH /api/v1/profile (multipart/form-data)
      def update_profile
        # Actualizamos siempre sobre @current_user (el dueño de la API Key)
        if @current_user.update(profile_params)
          render json: user_json(@current_user)
        else
          render json: { errors: @current_user.errors.full_messages }, status: :unprocessable_entity
        end
      end

      private

      def set_user
        @user = User.find(params[:id])
      end

      # Permitimos la descripción y el archivo del avatar
      def profile_params
        params.permit(:description, :avatar)
      end

      # Método de ayuda para formatear el JSON del usuario incluyendo la URL del avatar
      def user_json(user)
        {
          id: user.id,
          username: user.username,
          email: user.email,
          description: user.description,
          avatar_url: user.avatar.attached? ? url_for(user.avatar) : nil
        }
      end
    end
  end
end