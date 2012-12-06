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

  has_one :location, :as => :owner, :dependent => :destroy

  # Groups can be tagged with topics
  has_and_belongs_to_many :topics

  # Identifies user who tags as part of the acts-as-taggable-on gem
  #acts_as_tagger

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
