require "rails_helper"

RSpec.describe "Api::V1::Authentication", type: :request do
  let(:user) { create(:user) }
  describe "POST #login" do
    context "when user supply correct login details" do
      it "logs in the user" do
        post api_v1_login_path,
             params: { username: user.username, password: "validpass" }

        expect(response).to have_http_status(:success)
      end
    end

    context "when user supply invalid login details" do
      it "unauthorizes the user" do
        post api_v1_login_path,
             params: { username: user.username, password: "wrong" }

        expect(response).to have_http_status(401)
      end
    end
  end

  describe "GET #logout" do
    before { login_user(user) }

    context "when user supply a valid token header" do
      it "logs the user out and destroys the users token" do
        get api_v1_logout_path, headers: user_token(user)
        user.reload

        expect(user.token).to be_nil
      end
    end

    context "when user supply an invalid token header" do
      it "does not logout the user" do
        get api_v1_logout_path, headers: { token: "123.456" }
        user.reload

        expect(user.token).not_to be_nil
      end
    end
  end
end
