module Api
  module V1
    class UsersController < ApplicationController
      def create
        user = User.new(user_params)
        if user && user.save
          render json: user, status: :created
        else
          render json: { errors: user.errors.full_messages },
                 status: :unprocessable_entity
        end
      end

      def index
        render json: User.all
      end

      private

      def user_params
        params.require(:user).permit(:username,
                                     :email,
                                     :password,
                                     :password_confirmation)
      end
    end
  end
end
