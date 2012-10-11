# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :content do
    data Faker::Lorem.sentences(sentence_count = 3, supplemental = false)
    user
  end
end
