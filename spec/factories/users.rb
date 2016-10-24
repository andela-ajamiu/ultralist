FactoryGirl.define do
  factory :user do
    username { Faker::Internet.user_name }
    email { Faker::Internet.email }
    password "validpass"
    password_confirmation "validpass"
  end
end
