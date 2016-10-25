require 'rails_helper'

RSpec.describe "Bucketlists", type: :request do
  describe "GET /bucketlists" do
    it "works! (now write some real specs)" do
      get bucketlists_path
      expect(response).to have_http_status(200)
    end
  end
end
