FactoryGirl.define do
  factory :customer do
    first_name Faker::Name.first_name
    last_name Faker::Name.last_name
    sequence(:username) { |i| "#{Faker::Internet.user_name}#{i}" }
    sequence(:email) { |i| "#{Faker::Internet.user_name}#{i}@#{Faker::Internet.domain_name}" }
  end
end
