class TextContent < Content
  attr_accessible :text

  def description
    self.text
  end
end