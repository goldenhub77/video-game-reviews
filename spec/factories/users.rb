FactoryGirl.define do
  factory :user do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    sequence(:email) { |n| "#{Faker::Name.first_name}_#{Faker::Name.last_name}#{n}@example.com" }
    password 'password'
    password_confirmation 'password'
    role 'member'
  end
end
