module Api
  module V1
    class CommentsController < Api::BaseController
      # Filtres per carregar els recursos necessaris segons la jerarquia de la ruta
      before_action :set_issue, only: %i[index create]
      before_action :set_comment, only: %i[update destroy]
      
      # Protecció contra modificacions no autoritzades
      before_action :authorize_creator!, only: %i[update destroy]

      # GET /api/v1/issues/:issue_id/comments
      def index
        # Carreguem la col·lecció de comentaris associats a la incidència específica
        @comments = @issue.comments.order(created_at: :desc)
        render json: @comments
      end

      # POST /api/v1/issues/:issue_id/comments
      def create
        # Inicialitzem l'entitat associant-la explícitament a l'Issue i a l'usuari del token
        @comment = @issue.comments.build(comment_params)
        @comment.user = @current_user

        if @comment.save
          render json: @comment, status: :created
        else
          render json: { errors: @comment.errors.full_messages }, status: :unprocessable_entity
        end
      end

      # PUT/PATCH /api/v1/comments/:id
      def update
        if @comment.update(comment_params)
          render json: @comment
        else
          render json: { errors: @comment.errors.full_messages }, status: :unprocessable_entity
        end
      end

      # DELETE /api/v1/comments/:id
      def destroy
        @comment.destroy!
        head :no_content
      end

      private

      # Cerca la incidència pare a partir del paràmetre de la ruta niada
      def set_issue
        @issue = Issue.find(params[:issue_id])
      end

      # Cerca l'entitat directa per a les operacions d'escriptura (update/destroy)
      def set_comment
        @comment = Comment.find(params[:id])
      end

      # Validació: només el propietari del recurs pot alterar el seu estat
      def authorize_creator!
        unless @comment.user == @current_user
          render json: { error: "No tens permís per modificar aquest comentari" }, status: :forbidden
        end
      end

      # Filtrem estrictament els atributs que el client pot injectar
      def comment_params
        params.require(:comment).permit(:content)
      end
    end
  end
end