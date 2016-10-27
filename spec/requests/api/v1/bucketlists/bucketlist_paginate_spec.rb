require "rails_helper"

RSpec.describe "Paginating BucketLists", type: :request do
  let(:user) { create(:user) }
  before { 150.times { create(:bucketlist, user_id: user.id) } }

  context "as an authenticated user" do
    before { login_user(user) }

    context "with a page and limit parameter" do
      context "when limit > 100" do
        it "returns a maximum of 100 bucketlists" do
          get api_v1_bucketlists_path,
              params: { page: 1, limit: 120 },
              headers: user_token(user)

          expect(json_response.count).to eq(100)
          expect(response).to have_http_status :success
        end
      end

      context "when limit < 100" do
        it "returns bucketlists limited by the limit parameter" do
          get api_v1_bucketlists_path,
              params: { page: 1, limit: 50 },
              headers: user_token(user)

          expect(json_response.count).to eq(50)
          expect(response).to have_http_status :success
        end
      end
    end

    context "with a page and no limit parameter specified" do
      it "returns a default of 20 bucketlists" do
        get api_v1_bucketlists_path,
            params: { page: 1, limit: nil },
            headers: user_token(user)

        expect(json_response.count).to eq(20)
        expect(response).to have_http_status :success
      end
    end

    context "with limit and no page parameter specified" do
      it "returns all bucketlists limited by the limit parameter" do
        get api_v1_bucketlists_path,
            params: { page: nil, limit: 1 },
            headers: user_token(user)

        expect(json_response.count).to eq(1)
        expect(response).to have_http_status :success
      end
    end

    context "with no limit and no page parameter specified" do
      it "returns a default of 20 bucketLists starting from the first" do
        get api_v1_bucketlists_path,
            params: { page: nil, limit: nil },
            headers: user_token(user)

        expect(json_response.count).to eq(20)
        expect(response).to have_http_status :success
      end
    end
  end

  context "as an unauthenticated user" do
    it "responds with a 401 status error" do
      get api_v1_bucketlists_path,
          params: { page: 1, limit: 120 },
          headers: user_token(user)

      expect(json_response[:error]).to eq "Empty or Invalid header token"
      expect(response).to have_http_status :unauthorized
    end
  end
end
