require "rails_helper"

RSpec.describe "Api::V1::Authentication", type: :request do
  let(:user) { create(:user) }

  describe "POST #login" do
    context "when user supply correct login details" do
      it "logs in the user" do
        post api_v1_login_path,
             params: { username: user.username, password: "validpass" }

        user.reload
        expect(json_response[:token]).to eq user.token
        expect(response).to have_http_status(:success)
      end
    end

    context "when user supply invalid login details" do
      it "unauthorizes the user" do
        post api_v1_login_path,
             params: { username: user.username, password: "wrong" }

        expect(json_response[:error]).to eq Message.invalid_login
        expect(response).to have_http_status :unauthorized
      end
    end
  end

  describe "GET #logged_in" do
    before { login_user(user) }

    context "when user supply a token that is yet to expire" do
      it "shows that the user is still logged in" do
        get api_v1_logged_in_path,
            headers: user_token(user)

        user.reload
        expect(json_response[:message]).to eq Message.logged_in
        expect(json_response[:expires_at]).to eq((DateTime.now + 5.hours).
          strftime("%A, %d/%b/%Y %l:%M%p"))
        expect(response).to have_http_status(:success)
      end
    end

    context "when user supply an expired token" do
      before { Time.stub(:now).and_return(DateTime.now + 6.hours) }

      it "unauthorizes the user" do
        get api_v1_logged_in_path,
            headers: user_token(user)

        user.reload
        expect(json_response[:error]).to eq Message.empty_invalid_token
        expect(response).to have_http_status :unauthorized
      end
    end
  end

  describe "GET #logout" do
    before { login_user(user) }

    context "when user supply a valid token header" do
      it "logs the user out and destroys the users token" do
        get api_v1_logout_path, headers: user_token(user)

        user.reload
        expect(json_response[:message]).to eq Message.logout
        expect(user.token).to be_nil
      end
    end

    context "when user supply a previously issued token that has not expire" do
      before do
        user.reload
        @first_token = user.token
      end

      it "does not logout the user" do
        sleep 2
        login_user(user)
        user.reload

        get api_v1_logout_path, headers: { token: @first_token }

        expect(json_response[:error]).to eq Message.unauthorized_user
        expect(response).to have_http_status :unauthorized
      end
    end

    context "when user supply an invalid token header" do
      it "does not logout the user" do
        get api_v1_logout_path, headers: { token: "123.456" }

        user.reload
        expect(json_response[:error]).to eq Message.empty_invalid_token
        expect(user.token).not_to be_nil
      end
    end
  end
end
