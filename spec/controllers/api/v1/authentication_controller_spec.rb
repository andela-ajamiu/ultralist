require 'rails_helper'

RSpec.describe Api::V1::AuthenticationController, type: :controller do

  describe "POST #login" do
    let(:user) { create(:user) }
    context "when user supply correct login details" do
      it "should login the user" do
        post :login, params: { username: user.username, password: user.password }

        expect(response).to have_http_status(:success)
      end
    end

    context "when user supply invalid login details" do
      it "should login the user" do
        post :login, params: { username: user.username, password: "wrong" }

        expect(response).to have_http_status(401)
      end
    end
  end

  describe "GET #logout" do
    it "returns http success" do
      get :logout
      expect(response).to have_http_status(:success)
    end
  end
end
