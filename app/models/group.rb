class Group < ActiveRecord::Base
  attr_accessible :name

  #has_many :users, :as => :admins
  #has_many :users, :as => :members

  #has_many :members, class_name: "User"
  #has_many :admins, class_name: "User"

  #has_many :users, :as => :admins
  #has_many :users, :as => :members

  has_and_belongs_to_many :admins, 
    join_table: "admins_groups",
    class_name: "User",
    association_foreign_key: "admin_id"
  
  has_and_belongs_to_many :members,
    join_table: "members_groups",
    class_name: "User",
    association_foreign_key: "member_id"

  has_one :location, :as => :owner

  after_create :create_location

  def create_location
    location = Location.new
    location.owner_id = self.id
    location.owner_type = 'Group'
    location.save
  end
end
