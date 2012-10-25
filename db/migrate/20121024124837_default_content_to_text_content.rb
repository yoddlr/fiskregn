class DefaultContentToTextContent < ActiveRecord::Migration
  def up
    Content.all.each do |content|
      content.type = 'TextContent' if content.text
      content.save
    end
  end

  def down
    Content.all.each do |content|
      content.type = nil if content.text
      content.save
    end
  end
end
