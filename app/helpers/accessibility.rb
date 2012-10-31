module Accessibility

  def find_by_sql(*args)
    records = super(*args)

    # Do filtering.
    records = records.sample(1)

    return records
  end

  def method_missing(name, *args)
    ALog.debug 'Missing method: ' + name.to_s
    ALog.debug *args
    super(*args)
  end
end