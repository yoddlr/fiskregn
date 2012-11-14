# Intercept ActiveRecord method to enable filtered results. Statically import to applicable models.
module Accessibility

  # Accessibility for entity model Content and its subclasses
  module Content

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