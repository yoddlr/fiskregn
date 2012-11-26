# Adding 100 users, each with 10 content items with read access for 10 random users
# Login password for all users 'abc123'
# Run like: 'rake db:load_data'
# NOTE: This is huge a task and rake is an inefficient tool => minutes or hours!

require 'rake'

namespace :db do
  task :load_data => :environment do
    puts 'Adding 100 users, each with 100 content items with read access for 10 random users'
    puts "Login password for all users 'abc123'"
    100.times do
      user = FactoryGirl::create :user
      print '.'
    end
    puts
    puts 'Done adding users'
    puts 'Creating 10 groups and adding 10 random users to each'
    10.times do
      group = Group.create(name: Faker::Lorem.words(1)[0])
      group.members << User.all.sample(10)
      print '.'
    end
    puts
    puts 'Done adding groups'
    print 'Adding read access'
    User.all.each do |user|
      10.times do
        content = TextContent.create text: Faker::Lorem.sentences(sentence_count = 1, supplemental = false), user: user
        content.publish_to_location(user.location)
        # Give some random users and groups read access to the new content
        User.all.sample(10).each do |reader|
          reader.tag(content, :with => ['read'], :on => 'access')
        end
        Group.all.sample(2).each do |greader|
          greader.tag(content, :with => ['read'], :on => 'access')
        end
      end
      print '.'
    end
    puts
  end
end
