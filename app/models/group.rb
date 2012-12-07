class Group < ActiveRecord::Base
  attr_accessible :name

  # Initial underscore in name is reserved for special groups, e.g. '_omni'
  validates :name, presence: true, uniqueness: true, format: {without: /^_/}

  has_and_belongs_to_many :admins, 
    join_table: "admins_groups",
    class_name: "User",
    association_foreign_key: "admin_id"
  
  has_and_belongs_to_many :members,
    join_table: "members_groups",
    class_name: "User",
    association_foreign_key: "member_id"
  
  # Can access content as reader_group
  has_and_belongs_to_many :readables,
    join_table: "readables_groups",
    association_foreign_key: "readable_id",
    class_name: "Content"

  has_one :location, :as => :owner, :dependent => :destroy

  # Access to a location as a publish_group
  has_and_belongs_to_many :publishable_locations,
    join_table: "locs_pub_groups",
    foreign_key: "publish_group_id",
    association_foreign_key: "location_id",
    class_name: "Location"

  # Groups can be tagged with topics
  has_and_belongs_to_many :topics

  after_create :create_location

  # Provide topic methods
  include TopicsHelper

  def create_location
    location = Location.new
    location.owner_id = self.id
    location.owner_type = 'Group'
    location.save
  end

end
