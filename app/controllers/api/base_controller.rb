module Api
  class BaseController < ActionController::API
    # errors 404 
    rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

    before_action :authenticate_user_by_api_key

    private

    def authenticate_user_by_api_key
      api_key = request.headers['X-Api-Key'] || params[:api_key]

      if api_key.blank?
        render json: { error: "No s'ha proporcionat cap API Key" }, status: :unauthorized
        return
      end

      @current_user = User.find_by(api_key: api_key)

      unless @current_user
        render json: { error: "API Key invàlida o inexistent" }, status: :unauthorized
      end
    end

    def record_not_found
      render json: { error: "Recurs no trobat" }, status: :not_found
    end
  end
end