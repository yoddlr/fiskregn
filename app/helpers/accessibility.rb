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
      records = Content.all
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
      # All readable locations
      records = Location.all
      user = User.current_user
      filtered_records = []
      # Find tag for Content - not Location
      find_tag = ActsAsTaggableOn::Tag.find_by_name('find')

      records.each do |record|
        record.contents.each do |content|
          # Always include locations containing owned content
          if user && (content.user_id == user.id)
            filtered_records << record
            # It's enough with one owned content.
            break
          end
          # No need to bother if nothing has find tag
          if find_tag
            taggings = ActsAsTaggableOn::Tagging.find_all_by_taggable_id(content.id)
            taggings.each do |tagging|
              if (tagging && tagging.taggable_type == 'Content')
                # TODO: All groups of which user is member
                filtered = tagging.tagger_type == 'User'
                filtered = filtered && (user && (tagging.tagger_id == user.id))
                filtered = filtered && (tagging.tag_id == find_tag.id)
                filtered = filtered && (tagging.context == 'access')

                # Include location as we have found a findable content in it. :)
                if filtered
                  filtered_records << record
                  # We are happy with only one
                  break
                end
              end
            end
          end
        end
      end
      filtered_records
    end

    # Returns locations with content tagged with the given tags and find-access.
    # @param interests as an array of interests
    def find_by_interest(interests)
      # TODO: Locations can have their own tags, but we ignore this for now.
      records = find_by_content
      filtered_records = []

      interests.each do |interest|
        # Interest for Content - not Location
        find_tag = ActsAsTaggableOn::Tag.find_by_name(interest)
        records.each do |record|
          record.contents.each do |content|
            # No need to bother if nothing has find tag
            if find_tag
              taggings = ActsAsTaggableOn::Tagging.find_all_by_taggable_id(content.id)
              taggings.each do |tagging|
                if (tagging && tagging.taggable_type == 'Content')
                  filtered = (tagging.tag_id == find_tag.id)
                  filtered = filtered && (tagging.context == 'interest')
                  if filtered
                    filtered_records << record
                    # We are happy with only one
                    break
                  end
                end
              end
            end
          end
        end
      end
      filtered_records
    end

    # Find all locations with publication access
    def find_by_publish
      # All readable locations
      records = Location.all
      filtered_records = []

      find_tag = ActsAsTaggableOn::Tag.find_by_name('publish')
      records.each do |record|
        # Always publication access to owned locations
        if User.current_user && (record.user_id == User.current_user.id)
          filtered_records << record
        end
        # No need to bother if nothing has publication access
        if find_tag
          taggings = ActsAsTaggableOn::Tagging.find_all_by_taggable_id(record.id)
          taggings.each do |tagging|
            if (tagging && tagging.taggable_type == 'Location')
              # TODO: All groups of which user is member
              filtered = tagging.tagger_type == 'User'
              filtered = filtered && (User.current_user && (tagging.tagger_id == User.current_user.id))
              filtered = filtered && (tagging.tag_id == find_tag.id)
              filtered = filtered && (tagging.context == 'access')
              if filtered
                filtered_records << record
                # Publication access OK => straight to next location record
                break
              end
            end
          end
        end
      end
      filtered_records
    end
  end

end
