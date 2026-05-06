module Api
  module V1
    class PrioritiesController < Api::BaseController
      before_action :set_priority, only: %i[show update destroy]

      # GET /api/v1/priorities
      def index
        @priorities = Priority.all
        render json: @priorities
      end

      # GET /api/v1/priorities/:id
      def show
        render json: @priority
      end

      # POST /api/v1/priorities
      def create
        @priority = Priority.new(priority_params)

        if @priority.save
          render json: @priority, status: :created
        else
          render json: { errors: @priority.errors.full_messages }, status: :unprocessable_entity
        end
      end

      # PUT/PATCH /api/v1/priorities/:id
      def update
        if @priority.update(priority_params)
          render json: @priority
        else
          render json: { errors: @priority.errors.full_messages }, status: :unprocessable_entity
        end
      end

      # DELETE /api/v1/priorities/:id
      def destroy
        @priority.destroy!
        head :no_content
      end

      private

      def set_priority
        @priority = Priority.find(params[:id])
      end

      def priority_params
        params.require(:priority).permit(:name, :color)
      end
    end
  end
end