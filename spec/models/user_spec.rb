require "rails_helper"

RSpec.describe User, type: :model do
  describe "validations" do
    it { is_expected.to validate_presence_of(:username) }
    it { is_expected.to validate_uniqueness_of(:username) }

    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_uniqueness_of(:email) }

    it { is_expected.to have_secure_password }
    it { is_expected.to validate_length_of(:password).is_at_least(6) }
    it { is_expected.to respond_to(:password) }
    it { is_expected.to respond_to(:password_confirmation) }
    it { is_expected.to respond_to(:password_digest) }
  end
end
