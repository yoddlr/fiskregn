# Adding 30 users, each with 30 content items with read access for 3 random users
# Login password for all users 'abc123'
# Run like: 'rake db:load_data'
# NOTE: Large count => huge a task and rake is an inefficient tool => minutes or hours!

require 'rake'

# Count may be given as param - otherwise default to 3
count = ARGV[1].to_i
if !(count)
  puts "Usage: rake db:load_data count (default count = 3)"
  count = '3'.to_i
end

countcount = 10*count

namespace :db do
  task :load_data => :environment do
    puts "Adding #{countcount} users, each with #{countcount} content items with read access for #{count} random users"
    puts "Login password for all users 'abc123'"
    countcount.times do
      user = FactoryGirl::create :user
      print '.'
    end
    puts
    puts 'Done adding users'
    puts "Creating #{count} groups and adding #{count} random users to each"
    count.times do
      group = Group.create(name: Faker::Lorem.words(1)[0])
      group.members << User.all.sample(10)
      print '.'
    end
    puts
    puts 'Done adding groups'
    print 'Adding read access'
    User.all.each do |user|
      count.times do
        content = TextContent.create text: Faker::Lorem.sentences(sentence_count = 1, supplemental = false), user: user
        content.publish_to_location(user.location)
        Give some random users and groups read access to the new content
        User.all.sample(count).each do |reader|
          reader.tag(content, :with => ['find','read'], :on => 'access')
        end
        Group.all.sample(count/3).each do |greader|
          greader.tag(content, :with => ['find','read'], :on => 'access')
        end
      end
      print '.'
    end
    puts
  end
end
