FactoryGirl.define do
  factory :topic, :class => 'Topics' do
    text Faker::Lorem.words(1).first
  end
end
