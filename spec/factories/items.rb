FactoryGirl.define do
  factory :item do
    sequence(:name) { |n| "Abuja#{n}" }
    done false
    bucketlist nil
  end
end
