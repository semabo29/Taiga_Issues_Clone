module Api
  module V1
    class IssuesController < Api::BaseController
      before_action :set_issue, only: %i[show update destroy]
      
      before_action :authorize_creator!, only: %i[update destroy]

     # # GET /api/v1/issues
      # GET /api/v1/issues
      def index
        # Mapatge de l'API cap a les columnes i taules de la base de dades
        sort_mapping = {
          "id"       => "issues.id",
          "type"     => "issue_types.name",
          "severity" => "severities.name",
          "priority" => "priorities.name",
          "status"   => "statuses.name",
          "deadline" => "issues.deadline",
          "creator"  => "users.username",
          "assignee" => "assignees.username"
        }
        
        sort_column = sort_mapping[params[:sort]] || "issues.id"
        sort_direction = %w[asc desc].include?(params[:direction]) ? params[:direction] : "desc"
        
        # Realitzem JOINs amb les taules del diccionari per habilitar el filtratge per text (String)
        # S'empra un JOIN manual per 'assignees' per prevenir col·lisions amb la taula 'users' del creador
        @issues = Issue.left_outer_joins(:issue_type, :severity, :priority, :status, :user)
                       .joins("LEFT OUTER JOIN users AS assignees ON assignees.id = issues.assigned_to_id")
        
        # Aplicació de l'ordenació resolta
        @issues = @issues.order("#{sort_column} #{sort_direction}")

        # Cerca de coincidències parcials als camps de text de la incidència
        if params[:query].present?
          search_term = "%#{params[:query]}%"
          @issues = @issues.where("issues.subject LIKE ? OR issues.description LIKE ?", search_term, search_term)
        end

        # Filtres d'igualtat estricta sobre les taules unides segons el contracte de l'API
        @issues = @issues.where(issue_types: { name: params[:type] }) if params[:type].present?
        @issues = @issues.where(severities: { name: params[:severity] }) if params[:severity].present?
        @issues = @issues.where(priorities: { name: params[:priority] }) if params[:priority].present?
        @issues = @issues.where(statuses: { name: params[:status] }) if params[:status].present?

        render json: @issues
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
              # Creem la issue amb els valors per defecte de l'aplicació
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