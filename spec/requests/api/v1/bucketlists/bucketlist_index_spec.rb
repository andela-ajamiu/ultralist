require "rails_helper"

RSpec.describe "BucketLists #index", type: :request do
  let(:user) { create(:user) }
  before { create(:bucketlist, user_id: user.id) }
  let(:bucketlist) { user.bucketlists.first }

  context "when an authenticated user" do
    before { login_user(user) }

    context "when bucketlists are present" do
      it "returns all bucket lists" do
        get api_v1_bucketlists_path, headers: user_token(user)

        expect(json_response.count).to eq(user.bucketlists.count)
        expect(response.status).to eq(200)
      end
    end

    context "when bucketlists are not found" do
      it "returns a 'No Bucket List found'" do
        user.bucketlists.destroy_all

        get api_v1_bucketlists_path, headers: user_token(user)

        expect(json_response[:message]).to eq "No Bucketlist at the moment"
        expect(response.status).to eq(200)
      end
    end
  end

  context "when an unauthenticated user" do
    it "responds with a 401 http status code" do
      get api_v1_bucketlists_path

      expect(response.status).to eq(401)
    end
  end

  context "when a logged in user with invalid token" do
    before { login_user(user) }

    it "returns an error message with a 401 http status code" do
      get api_v1_bucketlists_path, headers: { token: "123.456" }

      expect(json_response[:error]).to eq "Empty or Invalid header token"
      expect(response.status).to eq(401)
    end
  end
end
