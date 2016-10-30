require "rails_helper"

RSpec.describe Bucketlist, type: :model do
  describe "associations" do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to have_many(:items) }
  end

  describe "validations" do
    it { is_expected.to validate_presence_of(:name) }
  end

  describe "class methods" do
    let(:user) { create(:user) }
    before { 350.times { create(:bucketlist, user_id: user.id) } }

    describe ".paginate" do
      context "when bucket lists have been created" do
        it "returns a paginated bucket list" do
          expect(Bucketlist.paginate(1, 25)).to eq Bucketlist.all[0..24]
        end

        it "returns a paginated bucket list" do
          expect(Bucketlist.paginate(2, nil)).to eq Bucketlist.all[20..39]
        end

        it "returns a paginated bucket list" do
          expect(Bucketlist.paginate(3, 150)).to eq Bucketlist.all[200..299]
        end
      end

      context "when there are no bucket lists created" do
        before { Bucketlist.destroy_all }

        it "returns an empty array" do
          expect(Bucketlist.paginate(3, 60)).to eq []
        end
      end
    end

    describe ".search" do
      context "when query matches a bucket list" do
        it "returns the filtered list using the query supplied" do
          expect(Bucketlist.search("trav").count).to eq Bucketlist.count
        end
      end

      context "when query doesn't match a bucket list" do
        it "returns an empty array" do
          expect(Bucketlist.search("education")).to eq []
        end
      end
    end

    describe ".paginate_and_search" do
      context "when there is no bucketlist" do
        before { Bucketlist.destroy_all }

        it "returns an empty array" do
          paginated_list = Bucketlist.paginate_and_search(
            q: "travel",
            page: 1,
            limit: 2
          )

          expect(paginated_list).to eq []
        end
      end

      context "when there are bucketlists" do
        it "returns the paginated and query filtered list" do
          paginated_list = Bucketlist.paginate_and_search(
            q: "trave",
            page: 5,
            limit: 15
          )

          expect(paginated_list).to eq Bucketlist.all[60..74]
        end
      end
    end
  end
end
