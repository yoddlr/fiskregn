module Accessibility

  def new(*args)
    super(*args)
    # raise('Adding records not allowed')
  end

  def all(*args)
    result = super(*args)
    result.sample(2)
  end

  def find(*args)
    # super(1)
    super(*args)
  end

  def first(*args)
    raise('No access')
  end

  def first!(*args)
    raise('No access')
  end

  def last(*args)
    raise('No access')
  end

  def last!(*args)
    raise('No access')
  end

  def exists?(*args)
    raise('No access')
  end

  def any?(*args)
    raise('No access')
  end

  def many?(*args)
    raise('No access')
  end

  def destroy(*args)
    super(*args)
  end

  def destroy_all(*args)
     raise('No access')
  end

  def delete(*args)
    super(*args)
  end

  def delete_all(*args)
    raise('No access')
  end

  def update(*args)
    super(*args)
  end

  def update_all(*args)
    raise('No access')
  end

  def method_missing(name, *args)
    ALog.debug 'Missing method: ' + name.to_s
    ALog.debug *args
    super(*args)
  end
end