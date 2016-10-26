require "rails_helper"

RSpec.describe "BucketLists #show", type: :request do
  let(:user) { create(:user) }
  before { create(:bucketlist, user_id: user.id) }
  let(:bucketlist) { user.bucketlists.first }

  context "when an authenticated user" do
    before { login_user(user) }
    context "with a valid bucketlist id" do
      it "returns the specific bucketlist" do
        get api_v1_bucketlist_path(bucketlist.id), headers: user_token(user)

        expect(json_response[:name]).to eq(user.bucketlists.first.name)
        expect(response.status).to eq(200)
      end
    end

    context "with an invalid bucketlist id" do
      it "responds with a 404 http status code" do
        get api_v1_bucketlist_path(4), headers: user_token(user)

        expect(json_response[:error]).to eq("Bucketlist not found")
        expect(response.status).to eq(404)
      end
    end
  end

  context "when an unauthenticated user" do
    it "responds with a http 401 status code" do
      get api_v1_bucketlist_url(bucketlist.id)

      expect(response.status).to eq(401)
    end
  end
end
