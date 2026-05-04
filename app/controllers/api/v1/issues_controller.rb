module Api
  module V1
    class IssuesController < Api::BaseController
      # GET /api/v1/issues
      def index
        #  Columes
        sortable_columns = ["issue_type_id", "severity_id", "priority_id", "id", "deadline", "status_id", "assigned_to_id", "user_id"]
        
        # Ordre i direccio
        sort_column = sortable_columns.include?(params[:sort]) ? params[:sort] : "id"
        sort_direction = %w[asc desc].include?(params[:direction]) ? params[:direction] : "desc"
        
        # Aplicar el orden base
        @issues = Issue.all.order("#{sort_column} #{sort_direction}")

        # Cerca per text
        if params[:query].present?
          search_term = "%#{params[:query]}%"
          @issues = @issues.where("subject LIKE ? OR description LIKE ?", search_term, search_term)
        end

        # Altres filtres
        @issues = @issues.where(issue_type_id: params[:issue_type_id]) if params[:issue_type_id].present?
        @issues = @issues.where(severity_id: params[:severity_id]) if params[:severity_id].present?
        @issues = @issues.where(priority_id: params[:priority_id]) if params[:priority_id].present?
        @issues = @issues.where(status_id: params[:status_id]) if params[:status_id].present?

        # JSON
        render json: @issues
      end
    end
  end
end