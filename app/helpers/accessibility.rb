# Intercept ActiveRecord method to enable filtered results. Statically import to applicable models.
module Accessibility

  # Accessibility for entity model Content and its subclasses
  module Content

    # Generic retrieval for ALL ActiveRecord queries
    def find_by_sql(*args)
      records = super(*args)
      # Apply content access filters here
      # records.reject! do |record|
      #   record.user_id != User.current_user || User.current_user.id
      # end
      records
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