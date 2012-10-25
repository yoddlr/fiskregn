class Content < ActiveRecord::Base
  acts_as_taggable
  acts_as_taggable_on :text

  attr_accessible :user, :parent_id, :parent, :locations

  belongs_to :user

  belongs_to :parent, :class_name => 'Content'
  has_many :children, :class_name => 'Content', :foreign_key => :parent_id
  
  has_and_belongs_to_many :locations

  def description
    I18n.t('.content_deleted')
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
