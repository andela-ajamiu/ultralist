require 'rails_helper'

RSpec.describe "Api::V1::Users", type: :request do
  describe "POST #create" do
    context "when user registration is successful" do
      it "creates a new user" do
        post api_v1_register_path, params: attributes_for(:user)

        expect(json_response[:token]).to eq(User.last.token)
        expect(response).to have_http_status :created
      end
    end

    context "when user tries to register with invalid attributes" do
      it "returns unprocessible_entity error" do
        post api_v1_register_path, params: attributes_for(:user, email: "")

        expect(json_response[:errors]).to include("Email can't be blank")
        expect(response).to have_http_status(422)
      end
    end
  end
end
