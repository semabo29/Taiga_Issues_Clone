module Api
  class BaseController < ActionController::API
    before_action :authenticate_user_by_api_key

    private

    def authenticate_user_by_api_key
      # Busquem la clau a la capçalera 'X-Api-Key' o per paràmetre ?api_key=...
      api_key = request.headers['X-Api-Key'] || params[:api_key]

      # MEJORA: Si no envían token en absoluto, abortamos antes de hacer la consulta SQL
      if api_key.blank?
        render json: { error: "No s'ha proporcionat cap API Key" }, status: :unauthorized
        return
      end

      @current_user = User.find_by(api_key: api_key)

      unless @current_user
        render json: { error: "API Key invàlida o inexistent" }, status: :unauthorized
      end
    end
  end
end