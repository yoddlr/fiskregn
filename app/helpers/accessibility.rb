module Accessibility
  def self.content_i_can_see( content )
    #content.where(i can see)
  end

  #

  def self.check_current_user
    # TODO: GÖR INTE DEVISE DETTA?
    current_user ||= User.new
  end
end
