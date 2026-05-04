module Api
  module V1
    class IssuesController < Api::BaseController
      before_action :set_issue, only: %i[show update destroy]
      
      before_action :authorize_creator!, only: %i[update destroy]

      # GET /api/v1/issues
      def index
        # Ordenar
        sortable_columns = ["issue_type_id", "severity_id", "priority_id", "id", "deadline", "status_id", "assigned_to_id", "user_id"]
        
        sort_column = sortable_columns.include?(params[:sort]) ? params[:sort] : "id"
        sort_direction = %w[asc desc].include?(params[:direction]) ? params[:direction] : "desc"
        
        # Aplicar ordre
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

        render json: @issues
      end

      # GET /api/v1/issues/:id
      def show
        render json: @issue
      end

      # POST /api/v1/issues
      def create
        @issue = Issue.new(issue_params)
        @issue.user = @current_user

        if @issue.save
          render json: @issue, status: :created
        else
          render json: { errors: @issue.errors.full_messages }, status: :unprocessable_entity
        end
      end

      # PUT/PATCH /api/v1/issues/:id
      def update
        if @issue.update(issue_params)
          render json: @issue
        else
          render json: { errors: @issue.errors.full_messages }, status: :unprocessable_entity
        end
      end

      # DELETE /api/v1/issues/:id
      def destroy
        @issue.destroy!
        head :no_content
      end

      private

      def set_issue
        @issue = Issue.find(params[:id])
      end

      # Comprova que l'usuari de l'API Key sigui el creador de la incidència
      def authorize_creator!
        unless @issue.user == @current_user
          render json: { error: "No tens permís per editar aquesta incidència" }, status: :forbidden
        end
      end

      def issue_params
        params.require(:issue).permit(:subject, :description, :status_id, :priority_id, :severity_id, :issue_type_id, :deadline, :assigned_to_id, tag_ids: [])
      end
    end
  end
end