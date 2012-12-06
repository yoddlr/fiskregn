module Accessibility
  # Intercept and add to ActiveRecord methods to enable filtered results.
  # Statically import to applicable models.

  # The possible combinations and their significance are:
  # 
  #  Location + find: N.A.
  # 
  #  Location + read: Without read access a location will not exist in retrieval.
  #    Default for (group) all is read access on all locations.
  # 
  #  Location + publish: Allowing access to publish. Default being no such access.
  # 
  #  Content + find: Retrieving locations with findable but not necessarily readable content.
  # 
  #  Content + read: Without read access content will not exist in retrieval. A 
  #    location may thus be stated to contain a piece of content that will not appear
  #    when retrieving content for that location, i.e. find but no read access for
  #    the specific content.
  # 
  #  Content + publish: N.A.


  # Accessibility for entity model Content and its subclasses
  module Content

    # Generic retrieval for ALL ActiveRecord queries
    def find_by_sql(*args)
      # start = Time.now.usec
      records = super(*args)
      # ALog.debug ''
      # ALog.debug 'Retrieval in usecs'
      # ALog.debug Time.now.usec - start
      filtered_records = []
      user = User.current_user
      # Nothing unless signed in
      if user
        user_groups = []
        Group.all.each do |group|
          user_groups << group if group.members.include?(user)
        end
        find_tag = ActsAsTaggableOn::Tag.find_by_name('read')
        records.each do |record|
          # Always allow find access to owned records
          if (record.user_id == user.id)
            filtered_records << record
            # Owned => no need to bother further with this record
            next
          end
          # No need to bother if nothing has read tag
          if find_tag
            taggings = ActsAsTaggableOn::Tagging.find_all_by_taggable_id(record.id)
            taggings.each do |tagging|
              if (tagging && tagging.taggable_type == 'Content')
                filtered = tagging.tag_id == find_tag.id
                filtered = filtered && (tagging.context == 'access')
                if filtered
                  if tagging.tagger_type == 'User'
                    # Access as individual user?
                    filtered_records << record if tagging.tagger_id == user.id
                  elsif tagging.tagger_type == 'Group'
                    # Access as member of a group
                    group_access = false
                    user_groups.each do |user_group|
                      group_access = tagging.tagger_id == user_group.id
                      # One found => no need to check all user's group
                      break if group_access
                    end
                    filtered_records << record if group_access
                  end
                end
              end
            end
          end
        end
      end
      # ALog.debug 'Retrieval + filtering in usecs'
      # ALog.debug Time.now.usec - start
      filtered_records.uniq
    end

    # Return records filtered by tags in interest context
    # @param interests as an array of interests
    def find_by_interest(interests)
      # Fetch all readable
      records = all
      filtered_records = []

      interests.each do |interest|
        find_tag = ActsAsTaggableOn::Tag.find_by_name(interest)
        if find_tag
          records.each do |record|
            taggings = ActsAsTaggableOn::Tagging.find_all_by_taggable_id(record.id)
            filtered = (tagging.tag_id == find_tag.id)
            filtered = filtered && (tagging.context == 'interest')
            if filtered
              filtered_records << record
            end
          end
        end
      end
      filtered_records
    end

  end


  # Accessibility for entity model Location and its subclasses
  module Location

    # Generic retrieval for ALL ActiveRecord queries
    def find_by_sql(*args)
      records = super(*args)
      filtered_records = []
      user = User.current_user
      user_groups = []
      # Omni is the default group even for non-logged in users
      user_groups << Group.find_by_name('_omni')
      Group.all.each do |group|
        user_groups << group if group.members.include?(user)
      end
      find_tag = ActsAsTaggableOn::Tag.find_by_name('read')

      records.each do |record|
        # Always allow find access to owned records
        if (user && (record.owner.id == user.id))
          filtered_records << record
          # Owned => no need to bother further with this record
          next
        end
        # No need to bother if nothing has read tag
        if find_tag
          taggings = ActsAsTaggableOn::Tagging.find_all_by_taggable_id(record.id)
          taggings.each do |tagging|
            if (tagging && tagging.taggable_type == 'Location')
              filtered = tagging.tag_id == find_tag.id
              filtered = filtered && (tagging.context == 'access')
              if filtered
                if tagging.tagger_type == 'User'
                  # Access as individual user?
                  filtered_records << record if tagging.tagger_id == user.id
                elsif tagging.tagger_type == 'Group'
                  # Access as member of a group
                  group_access = false
                  user_groups.each do |user_group|
                    group_access = (tagging.tagger_id == user_group.id)
                    # One found => no need to check all user's group
                    break if group_access
                  end
                  filtered_records << record if group_access
                end
              end
            end
          end
        end
        filtered_records.uniq
      end
    end

    # Find all readable locations with findable content
    def find_by_content
      user = User.current_user
      filtered_records = []
      user_groups = []
      tag = ActsAsTaggableOn::Tag.find_by_name('find')
      if tag
        # No need to bother without any find tags
        location_hashes = []
  
        # Omni is the default group even for non-logged in users
        user_groups << Group.find_by_name('_omni')
  
        if user
          Group.all.each do |group|
            user_groups << group if group.members.include?(user)
          end
        end

        # Retrieve all locations containing content where user's group(s) have find access
        user_groups.each do |user_group|
          sql = "SELECT DISTINCT location_id FROM contents_locations WHERE content_id IN (SELECT taggable_id FROM taggings WHERE taggable_type='Content' AND tag_id=#{tag.id} AND context='access' AND tagger_type='Group' AND tagger_id=#{user_group.id})"
          location_hashes += ActiveRecord::Base.connection.execute(sql)
        end

        if user
          # Retrieve all locations where user has find access
          sql = "SELECT DISTINCT location_id FROM contents_locations WHERE content_id IN (SELECT taggable_id FROM taggings WHERE taggable_type='Content' AND tag_id=#{tag.id} AND context='access' AND tagger_type='User' AND tagger_id=#{user.id})"
          location_hashes += ActiveRecord::Base.connection.execute(sql)
        end

        # No need to retrieve location object more than once
        location_hashes.uniq_by! {|hash| hash['location_id'] }

        locations = []
        location_hashes.each do |hash|
          locations << hash['location_id']
        end

        # All readable locations containing findable contents are OK
        all.each do |location|
          filtered_records << location if locations.include?(location.id)
        end
      end # No need to bother without any find tags
      filtered_records
    end

    # Returns locations with content tagged with the given tags and find-access.
    # @param interests as an array of interests
    def find_by_interest(interests)
      # TODO: Locations can have their own tags, but we ignore this for now.
      user = User.current_user
      filtered_records = []
      interest_ids = []
      user_groups = []
      tag = ActsAsTaggableOn::Tag.find_by_name('find')

      if tag
        # No need to bother without any find tags
        location_hashes = []

        # Omni is the default group even for non-logged in users
        user_groups << Group.find_by_name('_omni')

        if user
          Group.all.each do |group|
            user_groups << group if group.members.include?(user)
          end
        end

        interests.each do |interest|
          # Interest for Content - not Location
          find_tag = ActsAsTaggableOn::Tag.find_by_name(interest)
          if find_tag
            interest_ids << find_tag.id
          end
        end

        unless interest_ids.empty?
          # No need to bother if interests don't even exist
          # Retreive locations for group findable content and matching interest(s)
          user_groups.each do |user_group|
            # Locations for group findable content and matching interest(s)
            sql = "SELECT DISTINCT location_id FROM contents_locations WHERE content_id IN (SELECT taggable_id FROM taggings WHERE taggable_type='Content' AND tag_id=#{tag.id} AND context='access' AND tagger_type='Group' AND tagger_id=#{user_group.id}) AND content_id IN (SELECT taggable_id FROM taggings WHERE taggable_type='Content' AND tag_id IN (#{interest_ids.to_s.gsub(/[(\[\])]/,"")}) AND context='interest' AND tagger_type='Group' AND tagger_id=#{user_group.id})"
            location_hashes += ActiveRecord::Base.connection.execute(sql)
          end

          if user
            # Locations for user findable content and matching interest(s
            sql = "SELECT DISTINCT location_id FROM contents_locations WHERE content_id IN (SELECT taggable_id FROM taggings WHERE taggable_type='Content' AND tag_id=#{tag.id} AND context='access' AND tagger_type='User' AND tagger_id=#{user.id}) AND content_id IN (SELECT taggable_id FROM taggings WHERE taggable_type='Content' AND tag_id IN (#{interest_ids.to_s.gsub(/[(\[\])]/,"")}) AND context='interest' AND tagger_type='User' AND tagger_id=#{user.id})"
            location_hashes += ActiveRecord::Base.connection.execute(sql)
          end

          # No need to retrieve location object more than once
          location_hashes.uniq_by! {|hash| hash['location_id'] }
 
          locations = []
          location_hashes.each do |hash|
            locations << hash['location_id']
          end

          # Locations are OK if readable
          all.each do |location|
            filtered_records << location if locations.include?(location.id)
          end
        end
      end
      filtered_records.uniq
    end

    # Find all locations with publication access
    def find_by_publish
      user = User.current_user
      filtered_records = []
      user_groups = []
      tag = ActsAsTaggableOn::Tag.find_by_name('publish')

      # Always allow find access to owned location
      if user
        filtered_records << user.location
      end

      if tag
        # No need to bother without any publication tags
        location_hashes = []
  
        # Omni is the default group even for non-logged in users
        user_groups << Group.find_by_name('_omni')
  
        if user
          Group.all.each do |group|
            user_groups << group if group.members.include?(user)
          end
        end
  
        # Retrieve all locations where user's group(s) have publication access
        user_groups.each do |user_group|
          sql = "SELECT DISTINCT id AS location_id FROM locations WHERE id IN (SELECT taggable_id FROM taggings WHERE taggable_type='Location' AND tag_id=#{tag.id} AND context='access' AND tagger_type='Group' AND tagger_id=#{user_group.id})"
          location_hashes += ActiveRecord::Base.connection.execute(sql)
        end
  
        if user
          # Retrieve all locations where user has publication access
          sql = "SELECT DISTINCT id AS location_id FROM locations WHERE id IN (SELECT taggable_id FROM taggings WHERE taggable_type='Location' AND tag_id=#{tag.id} AND context='access' AND tagger_type='User' AND tagger_id=#{user.id})"
          location_hashes += ActiveRecord::Base.connection.execute(sql)
        end
  
        # No need to retrieve location object more than once
        location_hashes.uniq_by! {|hash| hash['location_id'] }

        locations = []
        location_hashes.each do |hash|
          locations << hash['location_id']
        end

        # Possibly paranoid guard against publication locations not being readable
        all.each do |location|
          filtered_records << location if locations.include?(location.id)
        end

      end # No need to bother without any publication tags
      filtered_records
    end
  end
end
