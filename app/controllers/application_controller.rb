class ApplicationController < ActionController::API
  require "jwt_authentication"

  private

  def update_token(user)
    token = JwtAuthentication.encode(user_id: user.id)
    user.update_attribute(:token, token)
  end

  def authenticate_token_and_user
    authenticate_token && authenticate_user
  end

  def authenticate_token
    if current_request_token && decode_payload[:data]
      true
    else
      render json: { error: "Empty or Invalid header token" },
             status: :unauthorized
      false
    end
  end

  def authenticate_user
    if logged_in_user && logged_in_user.token == current_request_token
      true
    else
      render json: { error: "Unauthorized User" }, status: :unauthorized
      false
    end
  end

  def logged_in_user
    User.find_by(id: decode_payload[:data][:user_id])
  end

  def current_request_token
    request.headers[:token]
  end

  def decode_payload
    JwtAuthentication.decode(current_request_token)
  end
end
