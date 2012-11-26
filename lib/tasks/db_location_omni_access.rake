# Add read access for group '_omni' (as default all users) to all(!) locations
# Run like: 'rake db:location_omni_access'

require 'rake'

namespace :db do
  task :location_omni_access => :environment do
    omni_group = Group.find_by_name('_omni')
    Location.all.each do |location|
      omni_group.tag(location, :with => ['read'], :on => 'access')
    end
  end
end
