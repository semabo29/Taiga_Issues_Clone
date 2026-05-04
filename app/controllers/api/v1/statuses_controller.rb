module Api
  module V1
    class StatusesController < Api::BaseController
      before_action :set_status, only: %i[show update destroy]

      # GET /api/v1/statuses
      def index
        @statuses = Status.all
        render json: @statuses
      end

      # GET /api/v1/statuses/:id
      def show
        render json: @status
      end

      # POST /api/v1/statuses
      def create
        @status = Status.new(status_params)

        if @status.save
          render json: @status, status: :created
        else
          render json: { errors: @status.errors.full_messages }, status: :unprocessable_entity
        end
      end

      # PUT/PATCH /api/v1/statuses/:id
      def update
        if @status.update(status_params)
          render json: @status
        else
          render json: { errors: @status.errors.full_messages }, status: :unprocessable_entity
        end
      end

      # DELETE /api/v1/statuses/:id
      def destroy
        @status.destroy!
        head :no_content
      end

      private

      def set_status
        @status = Status.find(params[:id])
      end

      def status_params
        params.require(:status).permit(:name, :color)
      end
    end
  end
end