require "rails_helper"

RSpec.describe "Items #index", type: :request do
  let(:user) { create(:user) }
  let(:bucketlist) { user.bucketlists.first }
  before do
    5.times { create(:bucketlist, user_id: user.id) }
    10.times { create(:item, bucketlist_id: bucketlist.id) }
  end

  context "when an authenticated user" do
    before { login_user(user) }

    context "with a valid bucketlist id" do
      it "returns all bucket list items" do
        get api_v1_bucketlist_items_path(bucketlist.id),
            headers: user_token(user)

        expect(json_response.first[:name]).to eq Item.first.name
        expect(json_response.count).to eq(bucketlist.items.count)
        expect(response).to have_http_status :success
      end
    end

    context "with a valid bucketlist id without any item" do
      before { Item.destroy_all }

      it "returns all bucket list items" do
        get api_v1_bucketlist_items_path(bucketlist.id),
            headers: user_token(user)

        expect(json_response[:message]).to eq Message.empty_bucketlist
        expect(response).to have_http_status :success
      end
    end

    context "with an invalid bucketlist id" do
      it "responds with a 404 http status" do
        get api_v1_bucketlist_items_path(6),
            headers: user_token(user)

        expect(json_response[:error]).to eq Message.bucketlist_not_found
        expect(response).to have_http_status :not_found
      end
    end
  end

  context "when an unauthenticated user" do
    it "responds with a 401 status" do
      get api_v1_bucketlist_items_path(bucketlist.id),
          headers: { token: "123.456" }

      expect(json_response[:error]).to eq Message.empty_invalid_token
      expect(response).to have_http_status :unauthorized
    end
  end
end
