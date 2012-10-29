# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user do
    sequence(:email) { Faker::Internet.email }
    password 'abc123'
    password_confirmation 'abc123'
  end
end
