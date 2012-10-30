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
  has_one :location

  # Identifies user who tags as part of the acts-as-taggable-on gem
  acts_as_tagger
  
  after_create :create_location
  
  def create_location
    location = Location.new
    location.user_id = self.id
    location.save
  end
end
