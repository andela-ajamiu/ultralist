require "rails_helper"

RSpec.describe "Items #update", type: :request do
  let(:user) { create(:user) }
  let(:bucketlist) { user.bucketlists.first }
  let(:item) { bucketlist.items.first }
  before do
    create(:bucketlist, user_id: user.id)
    create(:item, bucketlist_id: bucketlist.id)
  end

  context "when an authenticated user" do
    before { login_user(user) }

    context "with valid bucketlist_id and valid item_id" do
      it "updates the bucketlist item" do
        path_params = { bucketlist_id: bucketlist.id, id: item.id }
        update_params = { name: "New Name", done: true }
        put api_v1_bucketlist_item_path(path_params),
            params: update_params,
            headers: user_token(user)

        expect(json_response[:name]).to eq("New Name")
        expect(response).to have_http_status :success
      end
    end

    context "with an invalid bucketlist_id and valid item_id" do
      it "responds with a 404 http status code" do
        path_params = { bucketlist_id: 4, id: item.id }
        update_params = { name: "New Name", done: true }
        put api_v1_bucketlist_item_path(path_params),
            params: update_params,
            headers: user_token(user)

        expect(json_response[:error]).to eq "Bucketlist not found"
        expect(response).to have_http_status :not_found
      end
    end

    context "with a valid bucketlist_id and invalid item_id" do
      it "responds with a 404 http status" do
        path_params = { bucketlist_id: bucketlist.id, id: 3 }
        update_params = { name: "New Name", done: true }
        put api_v1_bucketlist_item_path(path_params),
            params: update_params,
            headers: user_token(user)

        expect(json_response[:error]).to eq "Bucketlist Item not found"
        expect(response).to have_http_status :not_found
      end
    end

    context "with a non unique item name" do
      it "responds with a 422 http status error" do
        path_params = { bucketlist_id: bucketlist.id, id: item.id }
        update_params = { name: item.name, done: true }
        put api_v1_bucketlist_item_path(path_params),
            params: update_params,
            headers: user_token(user)

        expect(response).to have_http_status :unprocessable_entity
      end
    end
  end

  context "as an unauthenticated user" do
    it "responds with a 401 http status error" do
      path_params = { bucketlist_id: bucketlist.id, id: item.id }
      update_params = { name: "New Name", done: true }
      put api_v1_bucketlist_item_path(path_params),
          params: update_params,
          headers: user_token(user)

      expect(json_response[:error]).to eq "Empty or Invalid header token"
      expect(response).to have_http_status :unauthorized
    end
  end
end
