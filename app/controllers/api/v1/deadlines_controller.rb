module Api
  module V1
    class DeadlinesController < Api::BaseController
      before_action :set_issue

      # GET /api/v1/issues/:issue_id/deadline
      # Visualitza la data límit de l'issue
      def show
        render json: { 
          issue_id: @issue.id, 
          due_date: @issue.due_date 
        }
      end

      # POST /api/v1/issues/:issue_id/deadline
      # Assigna o modifica la data límit
      def create
        # Acceptem el paràmetre 'due_date' (ex: "2024-12-31")
        if @issue.update(due_date: params[:due_date])
          render json: { 
            message: "Deadline actualitzat correctament", 
            due_date: @issue.due_date 
          }, status: :ok
        else
          render json: { errors: @issue.errors.full_messages }, status: :unprocessable_entity
        end
      end

      # DELETE /api/v1/issues/:issue_id/deadline
      # Elimina la data límit (la posa a nil)
      def destroy
        if @issue.update(due_date: nil)
          head :no_content # Codi 204 d'èxit (sense contingut)
        else
          render json: { error: "No s'ha pogut eliminar el deadline" }, status: :internal_server_error
        end
      end

      private

      def set_issue
        @issue = Issue.find(params[:issue_id])
      rescue ActiveRecord::RecordNotFound
        render json: { error: "Issue no trobada" }, status: :not_found
      end
    end
  end
end