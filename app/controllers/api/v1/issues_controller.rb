module Api
  module V1
    class IssuesController < Api::BaseController
      before_action :set_issue, only: %i[show update destroy]
      
      before_action :authorize_creator!, only: %i[update destroy]

      # GET /api/v1/issues
      # get /api/v1/issues
     # # GET /api/v1/issues
      def index
        # # Mapa per traduir els alias de Swagger a columnes reals de la base de dades
        # # Nota: creator apunta a la taula users, assignee apunta a l'associació assigned_to
        sort_mapping = {
          "id"       => "issues.id",
          "type"     => "issue_types.name",
          "severity" => "severities.name",
          "priority" => "priorities.name",
          "status"   => "statuses.name",
          "deadline" => "issues.deadline",
          "creator"  => "users.username",
          "assignee" => "assigned_tos_issues.username"
        }

        # # Determinar la columna d'ordenació real o defecte per ID
        sort_column = sort_mapping[params[:sort]] || "issues.id"
        sort_direction = %w[asc desc].include?(params[:direction]) ? params[:direction] : "desc"

        # # Fem left_outer_joins per poder filtrar/ordenar per noms sense perdre issues que tinguin camps nuls
        @issues = Issue.left_outer_joins(:issue_type, :severity, :priority, :status, :user, :assigned_to)

        # # Aplicar l'ordre final
        @issues = @issues.order("#{sort_column} #{sort_direction}")

        # # Cerca per text lliure (subject o description)
        if params[:query].present?
          search_term = "%#{params[:query]}%"
          @issues = @issues.where("issues.subject LIKE ? OR issues.description LIKE ?", search_term, search_term)
        end

        # # Filtres per nom de categoria (Strings) en lloc d'IDs, segons el nou contracte
        @issues = @issues.where(issue_types: { name: params[:type] }) if params[:type].present?
        @issues = @issues.where(statuses: { name: params[:status] }) if params[:status].present?
        @issues = @issues.where(severities: { name: params[:severity] }) if params[:severity].present?
        @issues = @issues.where(priorities: { name: params[:priority] }) if params[:priority].present?

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