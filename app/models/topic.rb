class Topic < ActiveRecord::Base
  attr_accessible :name
  has_and_belongs_to_many :contents
  has_and_belongs_to_many :locations
end
