# Rake task to remove all unused tags
# Run like: 'rake db:clean_tags'

require 'rake'

namespace :db do
  task :clean_tags => :environment do
    ActsAsTaggableOn::Tag.all.each do |tag|
      puts tag
    end
  end
end
