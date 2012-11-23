class Group < ActiveRecord::Base
  attr_accessible :name

  has_many :users, :as => :admins
  has_many :users, :as => :members

  has_one :location, :as => :owner

  after_create :create_location

  def create_location
    location = Location.new
    location.owner_id = self.id
    location.owner_type = 'group'
    location.save
  end
end
