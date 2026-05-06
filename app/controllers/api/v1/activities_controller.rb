module Api
  module V1
    class ActivitiesController < Api::BaseController
      before_action :set_issue

      # GET /api/v1/issues/:issue_id/activities
      def index
        # Obtenim totes les activitats de la issue, ordenades per la més recent
        @activities = @issue.activities.order(created_at: :desc)
        
        # Responem amb JSON, incloent la info de l'usuari que ha fet l'activitat
        render json: @activities.as_json(include: { user: { only: [:id, :username] } })
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