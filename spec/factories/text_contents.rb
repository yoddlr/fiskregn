FactoryGirl.define do
  factory :text_content do
    text Faker::Lorem.words(sentence_count = 1, supplemental = false)
    user
  end
end
