# Read about factories at https://github.com/thoughtbot/factory_girl

# TODO: Remove? Should not instantiate abstract class-objects, ever.

FactoryGirl.define do
  factory :content do
    # text Faker::Lorem.sentences(sentence_count = 3, supplemental = false)
    user
    factory :reply do
      parent :content
    end
  end
end
