class Content < ActiveRecord::Base
  attr_accessible :data, :user_id, :parent
  
  belongs_to :user 

  belongs_to :parent, :class_name => 'Content' 
  has_many :children, :class_name => 'Content', :foreign_key => :parent_id
end
