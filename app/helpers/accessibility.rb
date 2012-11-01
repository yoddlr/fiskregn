# Intercept ActiveRecord method to enable filtered results. Statically import to applicable models.
module Accessibility

  # Accessibility for entity model Content and its subclasses
  module Content
    def find_by_sql(*args)
      records = super(*args)
      # Apply content access filters here
      records
    end
  end

  # Accessibility for entity model Location and its subclasses
  module Location
    def find_by_sql(*args)
      records = super(*args)
      # Apply location access filters here
      records
    end
  end

end