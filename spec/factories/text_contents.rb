FactoryGirl.define do
  factory :text_content do
    text Faker::Lorem.sentences(sentence_count = 3, supplemental = false)
    user
    factory :text_reply do
      parent :content
    end
    factory :text_content_with_tags do
      tag_list 'tag, more tag'
    end
  end
end