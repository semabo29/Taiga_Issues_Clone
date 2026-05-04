module Api
  module V1
    class DeadlineShortcutsController < Api::BaseController
      before_action :set_deadline_shortcut, only: %i[show update destroy]

      # GET /api/v1/deadline_shortcuts
      def index
        @deadline_shortcuts = DeadlineShortcut.all
        render json: @deadline_shortcuts
      end

      # GET /api/v1/deadline_shortcuts/:id
      def show
        render json: @deadline_shortcut
      end

      # POST /api/v1/deadline_shortcuts
      def create
        @deadline_shortcut = DeadlineShortcut.new(deadline_shortcut_params)

        if @deadline_shortcut.save
          render json: @deadline_shortcut, status: :created
        else
          render json: { errors: @deadline_shortcut.errors.full_messages }, status: :unprocessable_entity
        end
      end

      # PUT/PATCH /api/v1/deadline_shortcuts/:id
      def update
        if @deadline_shortcut.update(deadline_shortcut_params)
          render json: @deadline_shortcut
        else
          render json: { errors: @deadline_shortcut.errors.full_messages }, status: :unprocessable_entity
        end
      end

      # DELETE /api/v1/deadline_shortcuts/:id
      def destroy
        @deadline_shortcut.destroy!
        head :no_content
      end

      private

      def set_deadline_shortcut
        @deadline_shortcut = DeadlineShortcut.find(params[:id])
      end

      def deadline_shortcut_params
        params.require(:deadline_shortcut).permit(:name, :offset_days)
      end
    end
  end
end