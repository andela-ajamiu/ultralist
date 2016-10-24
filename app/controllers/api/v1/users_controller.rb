module Api
  module V1
    class UsersController < ApplicationController
      def create
        user = User.new(user_params)
        if user.save
          update_token(user)
          render(json: user, status: :created) && return
        end
        render json: { errors: user.errors.full_messages },
               status: :unprocessable_entity
      end

      def index
        render(json: User.all) && return if User.exists?
        render json: { error: "No registered user at the moment" }
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
