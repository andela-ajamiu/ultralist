module Api
  module V1
    class UsersController < ApplicationController
      def create
        binding.pry
        user = User.new(user_params)
        render(json: user, status: :created) && return if user.save
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
