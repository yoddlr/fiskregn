class Content < ActiveRecord::Base
  attr_accessible :text, :user, :parent_id, :parent, :locations
  
  belongs_to :user 

  belongs_to :parent, :class_name => 'Content'
  has_many :children, :class_name => 'Content', :foreign_key => :parent_id
  
  has_and_belongs_to_many :locations

  def description
    # TODO: Change code so it uses the text_content as well.
    :text
    # I18n.t('.content_removed_message')
  end

  def publish_to_location(location)
    locations << location unless locations.include?(location)
  end
  
  def withdraw_from_location(location)
    locations.delete(location)
  end
  
  def publish_to_users_location(user)
    locations << user.location unless locations.include?(user.location)
  end
  
  def withdraw_from_users_location(user)
    locations.delete(user.location)
  end
end
