module Api
  module V1
    class WatchingsController < Api::BaseController
      before_action :set_issue

      # POST /api/v1/issues/:issue_id/watching
      def create
        # Si ens envien un user_id el busquem, sinó agafem l'usuari de l'API Key
        user_to_add = params[:user_id].present? ? User.find_by(id: params[:user_id]) : @current_user

        if user_to_add.nil?
          return render json: { error: "Usuari no trobat" }, status: :not_found
        end

        # Si l'usuari ja és watcher, no fem res per evitar duplicats
        if @issue.watchers.include?(user_to_add)
          render json: { message: "L'usuari ja és un watcher d'aquesta incidència" }, status: :ok
        else
          @issue.watchers << user_to_add
          render json: { message: "Watcher afegit correctament" }, status: :created
        end
      end

      # DELETE /api/v1/issues/:issue_id/watching
      def destroy
        # Mateixa lògica per eliminar
        user_to_remove = params[:user_id].present? ? User.find_by(id: params[:user_id]) : @current_user

        if user_to_remove.nil?
          return render json: { error: "Usuari no trobat" }, status: :not_found
        end

        @issue.watchers.delete(user_to_remove)
        head :no_content # Retorna un 204
      end
      
      #GET /api/v1/issues/{issue_id}/watching
      def show
        render json: @issue.watchers.select(:id, :username, :email)
      end

      private

      def set_issue
        @issue = Issue.find(params[:issue_id])
      rescue ActiveRecord::RecordNotFound
        render json: { error: "Incidència no trobada" }, status: :not_found
      end
    end
  end
end