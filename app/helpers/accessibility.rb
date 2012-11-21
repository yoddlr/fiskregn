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
      records = super(*args)
      filtered_records = []
      # Apply content access filters here
      find_tag = ActsAsTaggableOn::Tag.find_by_name('read')
      records.each do |record|
        # Always allow find access to owned records
        filtered_records << record if (User.current_user && (record.user_id == User.current_user.id))
        # No need to bother if nothing has read tag
        if find_tag
          taggings = ActsAsTaggableOn::Tagging.find_all_by_taggable_id(record.id)
          taggings.each do |tagging|
            if (tagging && tagging.taggable_type == 'Content')
              # TODO: All groups of which user is member
              filtered = tagging.tagger_type == 'User'
              filtered = filtered && (User.current_user && (tagging.tagger_id == User.current_user.id))
              filtered = filtered && (tagging.tag_id == find_tag.id)
              filtered = filtered && (tagging.context == 'access')
              filtered_records << record if filtered
            end
          end
        end
      end
      filtered_records.uniq!
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
      super(*args)
#       filtered_records = []
#       find_tag = ActsAsTaggableOn::Tag.find_by_name('read')
#       records.each do |record|
#       # Always allow find access to owned records
#       filtered_records << record if (User.current_user && (record.user_id == User.current_user.id))
#       # No need to bother if nothing has read tag
#       if find_tag
#         taggings = ActsAsTaggableOn::Tagging.find_all_by_taggable_id(record.id)
#         taggings.each do |tagging|
#           if (tagging && tagging.taggable_type == 'Location')
#             # TODO: All groups of which user is member
#             filtered = tagging.tagger_type == 'User'
#             filtered = filtered && (User.current_user && (tagging.tagger_id == User.current_user.id))
#             filtered = filtered && (tagging.tag_id == find_tag.id)
#             filtered = filtered && (tagging.context == 'access')
#             filtered_records << record if filtered
#           end
#         end
#       end
#       filtered_records.uniq!
#       end
    end

    # Find all readable locations with findable content
    def find_by_content
      # All readable locations
      records = Location.all
      filtered_records = []
      # Find tag for Content - not Location
      find_tag = ActsAsTaggableOn::Tag.find_by_name('find')

      records.each do |record|
        record.contents.each do |content|
          # Always include locations containing owned content
          if User.current_user && (content.user_id == User.current_user.id)
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
                filtered = filtered && (User.current_user && (tagging.tagger_id == User.current_user.id))
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
