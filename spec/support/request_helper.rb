module RequestHelper
  def login_user(user)
    post api_v1_login_path,
         params: { username: user.username, password: "validpass" }
    user.reload
  end

  def json_response
    JSON.parse(response.body, symbolize_names: true)
  end

  def user_token(user)
    { token: user.token }
  end
end
