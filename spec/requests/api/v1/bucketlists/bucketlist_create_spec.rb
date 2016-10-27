require "rails_helper"

RSpec.describe "Bucketlists #create", type: :request do
  let(:user) { create(:user) }
  let(:create_params) { attributes_for(:bucketlist, user_id: user.id) }

  context "when an authenticated user" do
    before { login_user(user) }

    context "when valid attributes are provided" do
      context "with a unique bucketlist name" do
        it "creates the bucketlist" do
          post api_v1_bucketlists_path,
               params: create_params,
               headers: user_token(user)

          expect(json_response[:name]).to eq Bucketlist.last.name
          expect(response).to have_http_status :created
        end
      end

      context "with a non unique bucketlist name" do
        before { create(:bucketlist, name: "Shopping", user_id: user.id) }

        it "does not create the bucketlist" do
          create_params = { name: "Shopping", user_id: user.id }

          post api_v1_bucketlists_path,
               params: create_params,
               headers: user_token(user)

          expect(json_response[:error]).to include "Name has already been taken"
          expect(response).to have_http_status :unprocessable_entity
        end
      end
    end

    context "when invalid attributes are provided" do
      it "does not create the bucketlist" do
        invalid_params = { invalid_name: "Invalid" }

        post api_v1_bucketlists_path,
             params: invalid_params,
             headers: user_token(user)

        expect(json_response[:error]).to include "Name can't be blank"
        expect(response).to have_http_status :unprocessable_entity
      end
    end
  end

  context "when an unauthenticated user" do
    it "does not create the bucketlist" do
      post api_v1_bucketlists_path,
           params: create_params,
           headers: user_token(user)

      expect(json_response[:error]).to eq "Empty or Invalid header token"
      expect(response).to have_http_status :unauthorized
    end
  end
end
