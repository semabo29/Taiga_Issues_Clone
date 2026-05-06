module Api
  module V1
    class SessionsController < ApplicationController
      skip_before_action :verify_authenticity_token, only: :create

      def create
        auth = request.env['omniauth.auth']
        
        user = User.from_omniauth(auth)
        
        if user
          session[:user_id] = user.id
          redirect_to root_path, notice: "Has iniciat sessió com a #{user.username}"
        else
          redirect_to root_path, alert: "Error en l'autentificació"
        end
      end

      def destroy
        session[:user_id] = nil
        redirect_to root_path, notice: "Sessió tancada", status: :see_other
      end
    end
  end
end