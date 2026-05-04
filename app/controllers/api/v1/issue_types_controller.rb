module Api
  module V1
    class IssueTypesController < Api::BaseController
      before_action :set_issue_type, only: %i[show update destroy]

      # GET /api/v1/issue_types
      def index
        @issue_types = IssueType.all
        render json: @issue_types
      end

      # GET /api/v1/issue_types/:id
      def show
        render json: @issue_type
      end

      # POST /api/v1/issue_types
      def create
        @issue_type = IssueType.new(issue_type_params)

        if @issue_type.save
          render json: @issue_type, status: :created
        else
          render json: { errors: @issue_type.errors.full_messages }, status: :unprocessable_entity
        end
      end

      # PUT/PATCH /api/v1/issue_types/:id
      def update
        if @issue_type.update(issue_type_params)
          render json: @issue_type
        else
          render json: { errors: @issue_type.errors.full_messages }, status: :unprocessable_entity
        end
      end

      # DELETE /api/v1/issue_types/:id
      def destroy
        @issue_type.destroy!
        head :no_content
      end

      private

      def set_issue_type
        @issue_type = IssueType.find(params[:id])
      end

      def issue_type_params
        params.require(:issue_type).permit(:name, :color)
      end
    end
  end
end