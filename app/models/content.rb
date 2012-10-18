class Content < ActiveRecord::Base
  attr_accessible :data, :user, :parent_id, :parent, :locations
  
  belongs_to :user 

  belongs_to :parent, :class_name => 'Content'
  has_many :children, :class_name => 'Content', :foreign_key => :parent_id
  
  has_and_belongs_to_many :locations
  
  def add_location(location)
    locations << location
  end
  
  def remove_location(location)
    locations.delete(location)
  end
  
  def add_users_location(user)
    locations << user.location
  end
  
  def remove_users_location(user)
    locations.delete(user.location)
  end
end
