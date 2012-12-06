class Location < ActiveRecord::Base

  belongs_to :owner, polymorphic: true
  has_and_belongs_to_many :contents

  #acts_as_taggable_on :access

  # Static import interception of ActiveRecord methods to enable filtered results
  class << self
    include Accessibility::Location
  end
end
