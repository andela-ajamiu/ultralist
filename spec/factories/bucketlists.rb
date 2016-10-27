FactoryGirl.define do
  factory :bucketlist do
    sequence(:name) { |n| "Travel #{n}" }
    user nil
  end
end
