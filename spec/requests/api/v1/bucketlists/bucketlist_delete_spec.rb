require "rails_helper"

RSpec.describe "Deleting BucketLists", type: :request do
  let(:user) { create(:user) }
  before { create(:bucketlist, user_id: user.id) }
  let(:bucketlist) { user.bucketlists.first }

  context "when an authenticated user" do
    before { login_user(user) }

    context "with a valid bucketlist id" do
      it "removes the bucket list" do
        delete api_v1_bucketlist_url(bucketlist.id),
               headers: user_token(user)

        expect(response.status).to eq(204)
      end
    end

    context "with an invalid bucketlist id" do
      it "does not remove the bucketlist" do
        delete api_v1_bucketlist_url(5),
               headers: user_token(user)

        expect(response.status).to eq(404)
      end
    end
  end

  context "when an unauthenticated user" do
    it "does not remove bucketlist" do
      delete api_v1_bucketlist_url(bucketlist.id),
             headers: user_token(user)

      expect(response.status).to eq(401)
    end
  end
end
