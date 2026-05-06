module Api
  module V1
    class IssuesController < Api::BaseController
      before_action :set_issue, only: %i[show update destroy]
      before_action :authorize_creator!, only: %i[update destroy]

      # GET /api/v1/issues
      def index
        sort_mapping = {
          "id"       => "issues.id",
          "type"     => "issues.issue_type_id",
          "severity" => "issues.severity_id",
          "priority" => "issues.priority_id",
          "status"   => "issues.status_id",
          "deadline" => "issues.deadline",
          "creator"  => "users.username",
          "assignee" => "assignees.username"
        }
        
        sort_column = sort_mapping[params[:sort]] || "issues.id"
        
        dir_param = params[:direction]&.downcase
        sort_direction = %w[asc desc].include?(dir_param) ? dir_param : "desc"
        
        # 3. Joins para permitir los filtros de texto
        @issues = Issue.left_outer_joins(:issue_type, :severity, :priority, :status, :user)
                       .joins("LEFT OUTER JOIN users AS assignees ON assignees.id = issues.assigned_to_id")
        
        @issues = @issues.order("#{sort_column} #{sort_direction}")

        if params[:query].present?
          search_term = "%#{params[:query]}%"
          @issues = @issues.where("issues.subject LIKE ? OR issues.description LIKE ?", search_term, search_term)
        end

        @issues = @issues.where(issue_types: { name: params[:type] }) if params[:type].present?
        @issues = @issues.where(severities: { name: params[:severity] }) if params[:severity].present?
        @issues = @issues.where(priorities: { name: params[:priority] }) if params[:priority].present?
        @issues = @issues.where(statuses: { name: params[:status] }) if params[:status].present?

        render json: @issues
      end

      # GET /api/v1/issues/:id
      def show
        render json: @issue
      end

      # POST /api/v1/issues
      def create
        @issue = Issue.new(issue_params)
        @issue.user = @current_user # Asignamos el dueño por la API Key

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
      
      # POST /api/v1/issues/bulk
      def bulk
        text_block = params[:text]

        if text_block.blank?
          return render json: { error: "El text no pot estar buit" }, status: :unprocessable_entity
        end

        subjects = text_block.split("\n").map(&:strip).reject(&:empty?)

        if subjects.empty?
          return render json: { error: "No s'han trobat incidències vàlides al text" }, status: :unprocessable_entity
        end

        default_status = Status.find_by(name: "New") || Status.first
        default_priority = Priority.find_by(name: "Normal") || Priority.first
        default_severity = Severity.find_by(name: "Normal") || Severity.first
        default_issue_type = IssueType.find_by(name: "Bug") || IssueType.first

        unless default_status && default_priority && default_severity && default_issue_type
          return render json: { error: "Falten configurar els estats o prioritats a la base de dades." }, status: :internal_server_error
        end

        creades = []

        begin
          Issue.transaction do
            subjects.each do |subject_line|
              nova_issue = Issue.create!(
                subject: subject_line,
                user: @current_user,
                status: default_status,
                priority: default_priority,
                severity: default_severity,
                issue_type: default_issue_type
              )
              creades << nova_issue
            end
          end

          render json: { 
            message: "S'han creat #{creades.count} incidències correctament", 
            issues: creades 
          }, status: :created

        rescue ActiveRecord::RecordInvalid => e
          render json: { error: "Error de validació: #{e.message}" }, status: :unprocessable_entity
        rescue => e
          render json: { error: "S'ha produït un error: #{e.message}" }, status: :internal_server_error
        end
      end

      private

      def set_issue
        @issue = Issue.find(params[:id])
      end

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