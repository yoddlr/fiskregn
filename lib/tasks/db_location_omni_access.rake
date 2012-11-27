# Add read access for group '_omni' (as default all users) to all(!) locations
# Run like: 'rake db:location_omni_access'

require 'rake'

namespace :db do
  task :location_omni_access => :environment do
    omni_group = Group.find_by_name('_omni')
    # Need raw SQL since Location is subjected to access control
    sql = 'SELECT * FROM Locations'
    locations = ActiveRecord::Base.connection.execute(sql)
    locations.each do |location|
      omni_group.tag(location, :with => ['read'], :on => 'access')
    end
  end
end
