require "rails_helper"

RSpec.describe "Items #create", type: :request do
  let(:user) { create(:user) }
  before { create(:bucketlist, user_id: user.id) }
  let(:bucketlist) { user.bucketlists.first }

  context "when an authenticated user" do
    before { login_user(user) }

    context "with a valid bucketlist id" do
      context "and a unique bucketlist item name" do
        it "creates the bucketlist item" do
          post api_v1_bucketlist_items_path(bucketlist.id),
               params: { name: "Chicago" },
               headers: user_token(user)

          expect(json_response[:name]).to eq Item.last.name
          expect(response).to have_http_status :created
        end
      end

      context "and a non-unique bucketlist item name" do
        before { create(:item, bucketlist_id: bucketlist.id) }

        it "does not create the bucketlist item" do
          post api_v1_bucketlist_items_path(bucketlist.id),
               params: user.bucketlists.first.items.first.attributes,
               headers: user_token(user)

          expect(json_response).to include "Name has already been taken"
          expect(response).to have_http_status :unprocessable_entity
        end
      end
    end

    context "with an invalid bucketlist id" do
      it "responds with a http 404 status error" do
        post api_v1_bucketlist_items_path(3),
             params: { name: "Chicago" },
             headers: user_token(user)

        expect(json_response[:error]).to eq "Bucketlist not found"
        expect(response).to have_http_status :not_found
      end
    end
  end

  context "when an unauthenticated user" do
    it "does not create the bucketlist" do
      post api_v1_bucketlist_items_path(bucketlist.id),
           params: { name: "Chicago" },
           headers: user_token(user)

      expect(json_response[:error]).to eq "Empty or Invalid header token"
      expect(response).to have_http_status :unauthorized
    end
  end
end
