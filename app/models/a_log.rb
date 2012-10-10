class ALog
  def self.debug(message=nil)
    # singleton
    @@a_log ||= Logger.new("#{Rails.root}/log/a.log")
    @@a_log.debug(Time.now)
    @@a_log.debug(message) unless message.nil?
  end
end