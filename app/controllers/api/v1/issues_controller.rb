module Api
  module V1
    class IssuesController < Api::BaseController
      before_action :set_issue, only: %i[show update destroy]
      
      before_action :authorize_creator!, only: %i[update destroy]

      # GET /api/v1/issues
      # get /api/v1/issues
      def index
        @issues = Issue.all

        # filtre per query de text (subject o description)
        if params[:query].present?
          search_term = "%#{params[:query]}%"
          @issues = @issues.where("subject ilike ? or description ilike ?", search_term, search_term)
        end

        # filtres exactes per nom usant joins per relacionar les taules
        @issues = @issues.joins(:issue_type).where(issue_types: { name: params[:type] }) if params[:type].present?
        @issues = @issues.joins(:status).where(statuses: { name: params[:status] }) if params[:status].present?
        @issues = @issues.joins(:severity).where(severities: { name: params[:severity] }) if params[:severity].present?
        @issues = @issues.joins(:priority).where(priorities: { name: params[:priority] }) if params[:priority].present?

        # ordenació
        if params[:sort].present?
          # assegurem que la direcció sigui vàlida, asc per defecte
          direction = %w[asc desc].include?(params[:direction]&.downcase) ? params[:direction].downcase : 'asc'

          case params[:sort].downcase
          when 'id'
            @issues = @issues.order(id: direction)
          when 'deadline'
            # utilitzem la columna real de la base de dades (due_date)
            @issues = @issues.order(due_date: direction)
          when 'type'
            @issues = @issues.left_joins(:issue_type).order("issue_types.name #{direction}")
          when 'status'
            @issues = @issues.left_joins(:status).order("statuses.name #{direction}")
          when 'severity'
            @issues = @issues.left_joins(:severity).order("severities.name #{direction}")
          when 'priority'
            @issues = @issues.left_joins(:priority).order("priorities.name #{direction}")
          when 'creator'
            @issues = @issues.left_joins(:user).order("users.username #{direction}")
          when 'assignee'
            @issues = @issues.left_joins(:assigned_to).order("users.username #{direction}")
          else
            # ordre per defecte si el camp no coincideix amb cap dels anteriors
            @issues = @issues.order(created_at: :desc)
          end
        else
          # ordre per defecte si no s'envia paràmetre sort
          @issues = @issues.order(created_at: :desc)
        end

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