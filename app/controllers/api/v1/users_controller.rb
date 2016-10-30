module Api
  module V1
    class UsersController < ApplicationController
      def create
        user = User.new(user_params)
        if user.save
          update_token(user)
          return render(json: { token: user.token }, status: :created)
        end
        render json: { error: user.errors.full_messages },
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
