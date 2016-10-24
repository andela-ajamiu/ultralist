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
    if current_request_token && decode_token_to_user_id
      true
    else
      render json: { error: "Empty or Invalid token, Please input the correct token in the request header" }, status: 401
      false
    end
  end

  def authenticate_user
    if current_user && current_user.token == current_request_token
      true
    else
      render json: { error: "Unauthorized User" }, status: 401
      false
    end
  end

  def current_user
    User.find_by(id: decode_token_to_user_id)
  end

  def current_request_token
    request.headers[:token]
  end

  def decode_token_to_user_id
    JwtAuthentication.decode(current_request_token)[:data][:user_id]
  end
end
