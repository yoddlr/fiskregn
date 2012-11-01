class Content < ActiveRecord::Base

  attr_accessible :user, :parent_id, :parent, :locations, :children

  belongs_to :user

  belongs_to :parent, :class_name => 'Content'
  has_many :children, :class_name => 'Content', :foreign_key => :parent_id
  
  has_and_belongs_to_many :locations

  acts_as_taggable

  # Static import interception of ActiveRecord methods to enable filtered results
  class << self
    include Accessibility::Content
  end

  def description
    I18n.t('.content_deleted')
  end

  # @deprecated tag_content form requires to call something in model (really?)
  def tag_strings
    ''
  end

  # Can not rely on local attribute for this => retrieve dynamically via ActsAsTaggableOn
  def tag_list(list = [])
    taggings = ActsAsTaggableOn::Tagging.find_all_by_taggable_id(id)
    if taggings
      taggings.each do |tagging|
        list << ActsAsTaggableOn::Tag.find(tagging.tag_id).name
      end
    end
    # return empty default or tags retrieved via ActsAsTaggableOn
    list
  end

  def publish_to_location(location)
    locations << location unless locations.include?(location)
  end
  
  def withdraw_from_location(location)
    locations.delete(location)
  end
  
  def publish_to_users_location(user)
    locations << user.location unless locations.include?(user.location)
  end
  
  def withdraw_from_users_location(user)
    locations.delete(user.location)
  end

end
