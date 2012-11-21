FactoryGirl.define do
  factory :text_content do
    text Faker::Lorem.sentences(sentence_count = 1, supplemental = false)
    user
  end
end
