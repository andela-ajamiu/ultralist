require 'rails_helper'

RSpec.describe Api::V1::UsersController, type: :controller do
  describe "POST #create" do
    context "when user registration is successful" do
      it "saves the expected username" do
        post :create, params: { user: attributes_for(:user) }

        json_response = JSON.parse(response.body)
        expect(json_response["username"]).to eq("emjay")
        expect(response).to have_http_status(:success)
        expect { post :create, user: attributes_for(:user) }.
          to change { User.count }.by(1)
      end
    end

    context "when user tries to register with invalid attributes" do
      it "saves the expected username" do
        post :create, params: { user: attributes_for(:user, email: "") }

        json_response = JSON.parse(response.body)
        expect(json_response["errors"]).to include("Email can't be blank")
        expect(response).to have_http_status(422)
        expect { post :create, user: attributes_for(:user, email: "") }.
          not_to change { User.count }
      end
    end
  end
end
