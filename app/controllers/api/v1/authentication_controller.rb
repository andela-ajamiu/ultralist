module Api
  module V1
    class AuthenticationController < ApplicationController
      def login
        binding.pry
        user = User.find_by(username: params[:username])
        if user && user.authenticate(params[:password])
          render json: user, status: 200
        else
          render json: { error: "Invalid Login Details" }, status: 401
        end
      end

      def logout
      end
    end
  end
end
