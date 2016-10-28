module Api
  module V1
    class UsersController < ApplicationController
      def create
        user = User.new(user_params)
        if user.save
          update_token(user)
          render(json: { token: user.token }, status: :created) && return
        end
        render json: { errors: user.errors.full_messages },
               status: :unprocessable_entity
      end

      private

      def user_params
        params.permit(:username,
                      :email,
                      :password,
                      :password_confirmation)
      end
    end
  end
end
