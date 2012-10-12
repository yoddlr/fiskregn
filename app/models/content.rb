class Content < ActiveRecord::Base
  attr_accessible :data, :user_id, :parent_id
  
  belongs_to :user
end
