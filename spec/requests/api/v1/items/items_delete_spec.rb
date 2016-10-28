require "rails_helper"

RSpec.describe "Deleting BucketList Items", type: :request do
  let(:user) { create(:user) }
  let(:bucketlist) { user.bucketlists.first }
  let(:item) { bucketlist.items.first }
  before do
    5.times { create(:bucketlist, user_id: user.id) }
    10.times { create(:item, bucketlist_id: bucketlist.id) }
  end

  context "when an authenticated user" do
    before { login_user(user) }

    context "with a valid bucketlist_id and item_id" do
      it "removes the bucketlist item" do
        path_params = { bucketlist_id: bucketlist.id, id: item.id }
        delete api_v1_bucketlist_item_path(path_params),
               headers: user_token(user)

        expect(json_response[:message]).to eq "Bucketlist Item deleted"
        expect(response).to have_http_status :success
      end
    end

    context "with a valid bucketlist_id and an invalid item_id" do
      it "responds with a 404 http status" do
        path_params = { bucketlist_id: 45, id: item.id }
        get api_v1_bucketlist_item_path(path_params),
            headers: user_token(user)

        expect(json_response[:error]).to eq "Bucketlist not found"
        expect(response).to have_http_status :not_found
      end
    end

    context "with an invalid bucketlist_id and valid item_id" do
      it "responds with a 404 http status" do
        path_params = { bucketlist_id: bucketlist.id, id: 38 }
        get api_v1_bucketlist_item_path(path_params),
            headers: user_token(user)

        expect(json_response[:error]).to eq "Bucketlist Item not found"
        expect(response).to have_http_status :not_found
      end
    end

    context "with an invalid bucketlist_id and invalid item_id" do
      it "responds with a 404 http status" do
        path_params = { bucketlist_id: 49, id: 77 }
        get api_v1_bucketlist_item_path(path_params),
            headers: user_token(user)

        expect(json_response[:error]).to eq "Bucketlist not found"
        expect(response).to have_http_status :not_found
      end
    end
  end

  context "when an unauthenticated user" do
    it "responds with a http 401 status error" do
      path_params = { bucketlist_id: bucketlist.id, id: item.id }
      get api_v1_bucketlist_item_path(path_params),
          headers: user_token(user)

      expect(json_response[:error]).to eq "Empty or Invalid header token"
      expect(response).to have_http_status :unauthorized
    end
  end
end
