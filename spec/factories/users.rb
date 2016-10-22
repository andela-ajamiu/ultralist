FactoryGirl.define do
  factory :user do
    username "emjay"
    email { Faker::Internet.email }
    password "invalid"
    password_confirmation "invalid"
  end
end
