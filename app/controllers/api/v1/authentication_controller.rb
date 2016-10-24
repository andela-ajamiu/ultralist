module Api
  module V1
    class AuthenticationController < ApplicationController
      def login
        user = User.find_by(username: params[:username])
        if user && user.authenticate(params[:password])
          update_token(user)
          render json: user, status: 200
        else
          render json: { error: "Invalid Login Details" }, status: 401
        end
      end

      def logged_in
        if authenticate_token_and_user
          expire_time = Time.at(JwtAuthentication.
                        decode(current_request_token)[:exp]).
                        strftime("%A, %d/%b/%Y %l:%M%p")

          render json: { success: "You are still logged in",
                         expires_at: expire_time },
                 status: 200
        end
      end

      def logout
      end
    end
  end
end
