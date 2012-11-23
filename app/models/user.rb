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
  
  has_many :contents
  has_one :location, :as => :owner

  has_and_belongs_to_many :groups

  # Identifies user who tags as part of the acts-as-taggable-on gem
  acts_as_tagger
  
  after_create :create_location

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

  
  def create_location
    location = Location.new
    location.owner_id = self.id
    location.owner_type = 'User'
    location.save
  end
end
