FactoryGirl.define do
  factory :topic, :class => 'Topic' do
    name Faker::Lorem.words(1).first
  end
end
