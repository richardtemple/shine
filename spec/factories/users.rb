FactoryGirl.define do
  factory :user do
    sequence(:email) { |i| "#{Faker::Internet.user_name}#{i}@example.com" }
    password "foobarblah"
  end
end
