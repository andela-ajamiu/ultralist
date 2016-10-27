require "rails_helper"

RSpec.describe "Searching BucketLists", type: :request do
  let(:user) { create(:user) }
  before { 20.times { create(:bucketlist, user_id: user.id) } }
  let(:bucketlist) { user.bucketlists.first }

  context "when an authenticated user" do
    before { login_user(user) }

    context "with a search query provided" do
      it "returns all bucketlists matching the search query" do
        get api_v1_bucketlists_path,
            params: { q: "Travel 104" },
            headers: user_token(user)

        search_results = json_response.map { |bucket| bucket[:name] }
        expect(search_results).to include("Travel 1044")
        expect(json_response.first[:name]).to eq bucketlist.name
        expect(response).to have_http_status :success
      end
    end

    context "with no search query provided" do
      it "returns all bucketlists" do
        get api_v1_bucketlists_path,
            headers: user_token(user)

        expect(json_response.count).to eq(user.bucketlists.count)
        expect(response).to have_http_status :success
      end
    end
  end

  context "when an unauthenticated user" do
    it "returns a 401 status error" do
      get api_v1_bucketlists_path,
          params: { q: "Travel 1" }

      expect(json_response[:error]).to eq "Empty or Invalid header token"
      expect(response).to have_http_status :unauthorized
    end
  end
end
