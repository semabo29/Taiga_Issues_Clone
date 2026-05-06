module Api
  module V1
    class AttachmentsController < Api::BaseController
      before_action :set_issue, only: %i[index create]
      before_action :set_attachment, only: %i[destroy]
      before_action :authorize_creator!, only: %i[destroy]

      # GET /api/v1/issues/:issue_id/attachments
      def index
        attachments_data = @issue.attachments.map do |attachment|
          {
            id: attachment.id,
            filename: attachment.filename.to_s,
            content_type: attachment.content_type,
            byte_size: attachment.byte_size,
            created_at: attachment.created_at,
            url: url_for(attachment) # Devuelve la URL para descargar/ver el archivo
          }
        end
        
        render json: attachments_data
      end

      # POST /api/v1/issues/:issue_id/attachments (Usa multipart/form-data)
      def create
        if params[:file].blank?
          return render json: { error: "No s'ha proporcionat cap fitxer." }, status: :unprocessable_entity
        end

        @issue.attachments.attach(params[:file])
        new_attachment = @issue.attachments.last

        render json: {
          id: new_attachment.id,
          filename: new_attachment.filename.to_s,
          url: url_for(new_attachment),
          message: "Fitxer pujat correctament"
        }, status: :created
      end

      # DELETE /api/v1/attachments/:id
      def destroy
        @attachment.purge
        head :no_content
      end

      private

      def set_issue
        @issue = Issue.find(params[:issue_id])
      end

      def set_attachment
        @attachment = ActiveStorage::Attachment.find(params[:id])
      end

      # Validamos que el current_user sea el dueño de la Issue donde se subió el archivo
      def authorize_creator!
        issue = @attachment.record
        unless issue.user == @current_user
          render json: { error: "No tens permís per eliminar aquest fitxer" }, status: :forbidden
        end
      end
    end
  end
end