# Rake task to remove all unused tags
# Run like: 'rake db:clean_tags'

require 'rake'

namespace :db do
  task :clean_tags => :environment do
    ActsAsTaggableOn::Tag.all.each do |tag|
      unless ActsAsTaggableOn::Tagging.find_by_tag_id(tag.id)
        puts 'Deleting tag: ' + tag.name
        tag.destroy
      end
    end
  end
end
