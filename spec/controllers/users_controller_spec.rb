require "rails_helper"

RSpec.describe UsersController, type: :controller do
  describe "POST #create" do
    context "when user registration is successful" do
      post :create, params: { user: attributes_for(:user) }

      it "saves the expected username" do
        expect(User.last.username).to eql("emjay")
      end
    end
  end
end
