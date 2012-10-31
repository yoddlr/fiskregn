module Accessibility

  def find_by_sql(*args)
    records = super(*args)
    select = args[0]
    if (select && select.kind_of?(Arel::SelectManager))
      case select.engine.name
        when 'Location'
          # Apply location access filters here
        when 'Content'
          # Apply content access filters here
        else
          # Unforeseen generic type filtering here
      end
    end
    return records
  end

end