module Api
  module V1
    class AuthenticationController < ApplicationController
      def login
        user = User.find_by(username: params[:username])
        if user && user.authenticate(params[:password])
          update_token(user)
          render json: { token: user.token }, status: 200
        else
          render json: { error: Message.invalid_login }, status: 401
        end
      end

      def logged_in
        if authenticate_token_and_user
          expire_time = Time.at(decode_payload[:exp]).
                        strftime("%A, %d/%b/%Y %l:%M%p")

          render json: { message: Message.logged_in,
                         expires_at: expire_time },
                 status: 200
        end
      end

      def logout
        if authenticate_token_and_user
          logged_in_user.update_attribute(:token, nil)
          render json: { message: Message.logout }, status: 200
        end
      end
    end
  end
end
