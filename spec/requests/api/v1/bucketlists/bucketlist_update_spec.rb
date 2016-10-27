require "rails_helper"

RSpec.describe "BucketLists #update", type: :request do
  let(:user) { create(:user) }
  before { 20.times { create(:bucketlist, user_id: user.id) } }
  let(:bucketlist) { user.bucketlists.first }

  context "when an authenticated user" do
    before { login_user(user) }

    context "with a valid bucketlist id" do
      it "updates the bucketlist" do
        put api_v1_bucketlist_path(bucketlist.id),
            params: { name: "Houses" },
            headers: user_token(user)

        user.reload
        expect(user.bucketlists.first.name).to eq "Houses"
        expect(response).to have_http_status :success
      end
    end

    context "with an invalid bucket_list id" do
      it "does not update the bucket list" do
        put api_v1_bucketlist_path(57),
            params: { name: "Cars" },
            headers: user_token(user)

        user.reload
        expect(user.bucketlists.first.name).to_not eq "Cars"
        expect(response).to have_http_status :not_found
      end
    end
  end

  context "when an unauthenticated user" do
    it "does not update the bucketlist" do
      put api_v1_bucketlist_path(bucketlist.id),
          params: { name: "Charity" },
          headers: user_token(user)

      user.reload
      expect(user.bucketlists.first.name).to_not eq "Charity"
      expect(response).to have_http_status :unauthorized
    end
  end
end
