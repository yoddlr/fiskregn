class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :location
  # attr_accessible :title, :body
  
  validates :email, presence: true, uniqueness: true
  validates :password, confirmation: true, length: {minimum: 6}, format: {with: /.*(^[A-z]+.*[0-9]+.*$)|(^[0-9]+.*[A-z]+.*$)/}
  
  has_many :contents, :dependent => :destroy
  has_one :location, :as => :owner, :dependent => :destroy

  # A user can have a relatioship with a group on two levels.
  # A user can be a member of a group,
  # And a user can also be a group administrator.
  # These relationships are maintaned separately in separate tables

  # the groups the user is a member of.
  has_and_belongs_to_many :groups,
    join_table: "members_groups",
    foreign_key: "member_id"

  # The groups in which the member is an admin.
  has_and_belongs_to_many :admin_groups,
    join_table: "admins_groups",
    foreign_key: "admin_id",
    class_name: "Group"

  # Can access content as a reader
  has_and_belongs_to_many :readables,
    join_table: "readables_users",
    association_foreign_key: "readable_id",
    class_name: "Content"

  after_create :create_location, :add_to_omni_group

  # Thanks: http://stackoverflow.com/questions/3742785/rails-3-devise-current-user-is-not-accessible-in-a-model
  # Make devise's current_user globally available. Static and ThreadLocal apparently...
  class << self
    def current_user=(user)
      Thread.current[:current_user] = user
    end

    def current_user
      Thread.current[:current_user]
    end
  end

  # Keeping common interface as location owner together with group
  def name
    email
  end

  def create_location
    location = Location.new
    location.owner_id = self.id
    location.owner_type = 'User'
    location.save
  end

  # User as part of all users
  def add_to_omni_group
    groups << Group.find_by_name('_omni')
  end
end
