# Intercept ActiveRecord method to enable filtered results. Statically import to applicable models.
module Accessibility

  # Accessibility for entity model Content and its subclasses
  module Content

    # 1. All content belong to one or more locations. (if not, it's not findable)
    # 2. Attribute findable is used ONLY with locations, so a location will
    #    report number of contents with given tags and is findable.
    # 3. You can never see a content which is not readable.
    # 4. Content model does not perform accessibility checks in its functions.
    #    NOTE: A content is simply not loaded into memory if it is not readable!!!!!!!

    # Generic retrieval for ALL ActiveRecord queries
    def find_by_sql(*args)
      records = super(*args)
      filtered_records = []
      # Apply content access filters here
      find_tag = ActsAsTaggableOn::Tag.find_by_name('find')
      records.each do |record|
        # Always allow find access to owned records
        filtered_records << record if (User.current_user && (record.user_id == User.current_user.id))
        # No need to bother if nothing has find tag
        if find_tag
          taggings = ActsAsTaggableOn::Tagging.find_all_by_taggable_id(record.id)
          taggings.each do |tagging|
            if (tagging && tagging.taggable_type == 'Content')
              filtered = tagging.tagger_type == 'User'
              filtered = filtered && (User.current_user && (tagging.tagger_id == User.current_user.id))
              filtered = filtered && (tagging.tag_id == find_tag.id)
              filtered = filtered && (tagging.context == 'access')
              filtered_records << record if filtered
            end
          end
        end
      end
      filtered_records
    end

    # Return records filtered by tags in interest context
    def find_by_interest(interests)
      # TODO: Yet to be implemented
      nil
    end

    # Return records filtered by accessibility
    def find_by_access(access)
      # TODO: Yet to be implemented
      nil
    end

    def count_items_in_group_with_tags(group_name,tags)
      # TODO: Return int count with number of items with all of the tags, in the given group.
    end

    # True if there is a current user with read access to content
    def readable?(content)
      ALog.debug content
      # Always allow read access to owned records
      readable = User.current_user && (content.user_id == User.current_user.id)
      unless readable
        read_tag = ActsAsTaggableOn::Tag.find_by_name('read')
        # No need to bother if nothing has read tag
        readable = content && content.kind_of?(Content) && read_tag
        if readable
          taggings = ActsAsTaggableOn::Tagging.find_all_by_taggable_id(content.id)
          taggings.each do |tagging|
          readable = tagging && tagging.taggable_type == 'Content'
            if readable
              readable = readable && tagging.tagger_type == 'User'
              readable = readable && (User.current_user && (tagging.tagger_id == User.current_user.id))
              readable = readable && (tagging.tag_id == find_tag.id)
              readable = readable && (tagging.context == 'access')
            end
          end
        end
      end #unless readable
      readable
    end

    # Read access check
    def restrict_read_access(*args)
      # Raise exception here if read access not allowed
    end
  end

  # Accessibility for entity model Location and its subclasses
  module Location

    # Generic retrieval for ALL ActiveRecord queries
    def find_by_sql(*args)
      records = super(*args)
      # Apply location access filters here
      records
    end

        # Return records filtered by accessibility
    def find_by_access(access)
      # TODO: Yet to be implemented
      nil
    end
  end

end