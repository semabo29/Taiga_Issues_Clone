module Api
  module V1
    class SeveritiesController < Api::BaseController
      before_action :set_severity, only: %i[show update destroy]

      # GET /api/v1/severities
      def index
        @severities = Severity.all
        render json: @severities
      end

      # GET /api/v1/severities/:id
      def show
        render json: @severity
      end

      # POST /api/v1/severities
      def create
        @severity = Severity.new(severity_params)

        if @severity.save
          render json: @severity, status: :created
        else
          render json: { errors: @severity.errors.full_messages }, status: :unprocessable_entity
        end
      end

      # PUT/PATCH /api/v1/severities/:id
      def update
        if @severity.update(severity_params)
          render json: @severity
        else
          render json: { errors: @severity.errors.full_messages }, status: :unprocessable_entity
        end
      end

      # DELETE /api/v1/severities/:id
      def destroy
        @severity.destroy!
        head :no_content
      end

      private

      def set_severity
        @severity = Severity.find(params[:id])
      end

      def severity_params
        params.require(:severity).permit(:name, :color)
      end
    end
  end
end