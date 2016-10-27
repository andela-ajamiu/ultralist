require "rails_helper"

RSpec.describe "Bucketlists #delete", type: :request do
  let(:user) { create(:user) }
  before { 20.times { create(:bucketlist, user_id: user.id) } }
  let(:bucketlist) { user.bucketlists.first }

  context "when an authenticated user" do
    before { login_user(user) }

    context "with a valid bucketlist id" do
      it "removes the bucket list" do
        delete api_v1_bucketlist_url(bucketlist.id),
               headers: user_token(user)

        expect(json_response[:message]).to eq "Bucketlist successfully deleted"
        expect(response).to have_http_status :success
      end
    end

    context "with an invalid bucketlist id" do
      it "does not remove the bucketlist" do
        delete api_v1_bucketlist_url(55),
               headers: user_token(user)

        expect(json_response[:error]).to eq "Bucketlist not found"
        expect(response).to have_http_status :not_found
      end
    end
  end

  context "when an unauthenticated user" do
    it "does not remove bucketlist" do
      delete api_v1_bucketlist_url(bucketlist.id),
             headers: user_token(user)

      expect(json_response[:error]).to eq "Empty or Invalid header token"
      expect(response).to have_http_status :unauthorized
    end
  end
end
