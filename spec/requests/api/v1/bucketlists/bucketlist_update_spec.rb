require "rails_helper"

RSpec.describe "Updating BucketLists", type: :request do
  let(:user) { create(:user) }
  before { create(:bucketlist, user_id: user.id) }
  let(:bucketlist) { user.bucketlists.first }

  context "when an authenticated user" do
    before { login_user(user) }

    context "with a valid bucketlist id" do
      it "updates the bucketlist" do
        update_params = { name: "Houses" }

        put api_v1_bucketlist_path(bucketlist.id),
            params: { bucketlist: update_params },
            headers: user_token(user)

        user.reload
        expect(user.bucketlists.first.name).to eq "Houses"
        expect(response.status).to eq(200)
      end
    end

    context "with an invalid bucket_list id" do
      it "does not update the bucket list" do
        update_params = { name: "Cars" }

        put api_v1_bucketlist_path(5),
            params: { bucketlist: update_params },
            headers: user_token(user)

        user.reload
        expect(user.bucketlists.first.name).to_not eq "Cars"
        expect(response.status).to eq(404)
      end
    end
  end

  context "when an unauthenticated user" do
    it "does not update the bucketlist" do
      update_params = { name: "Charity" }

      put api_v1_bucketlist_path(bucketlist.id),
          params: { bucketlist: update_params },
          headers: user_token(user)

      user.reload
      expect(user.bucketlists.first.name).to_not eq "Charity"
      expect(response.status).to eq(401)
    end
  end
end
