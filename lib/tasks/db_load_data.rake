# Adding 100 users, each with 10 content items with read access for 10 random users
# Login password for all users 'abc123'
# Run like: 'rake db:load_data'
# NOTE: This is huge task and rake is an inefficient tool => several minutes!

require 'rake'

namespace :db do
  task :load_data => :environment do
    puts 'Adding 100 users, each with 100 content items with read access for 10 random users'
    puts "Login password for all users 'abc123'"
    100.times do
      user = FactoryGirl::create :user
    end
    puts 'Done adding users'
    User.all.each do |user|
      10.times do
        content = TextContent.create text: Faker::Lorem.sentences(sentence_count = 1, supplemental = false), user: user
        content.publish_to_location(user.location)
        User.all.sample(10).each do |reader|
          reader.tag(content, :with => ['read'], :on => 'access')
        end
      end
    end
  end
end