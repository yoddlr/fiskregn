class Content < ActiveRecord::Base

  attr_accessible :user, :parent_id, :parent, :locations, :children

  belongs_to :user

  belongs_to :parent, :class_name => 'Content'
  has_many :children, :class_name => 'Content', :foreign_key => :parent_id

  has_and_belongs_to_many :readers,
    join_table: "readables_users",
    foreign_key: "readable_id",
    class_name: "User"

  has_and_belongs_to_many :reader_groups,
    join_table: "readables_groups",
    foreign_key: "readable_id",
    class_name: "Group"
  
  has_and_belongs_to_many :locations

  # The only reason to use this instead of has_and_belongs_to_many is when
  # the location_topics table has extra columns, like 'approved' in place_users.
  #
  # See http://stackoverflow.com/questions/4924156/habtm-and-accepts-nested-attributes-for
  # has_many :content_topics, :foreign_key => "content_id"
  # has_many :topics, :through => :content_topics
  #
  has_and_belongs_to_many :topics

  # Provides methods for adding, removing and finding by topics
  include TopicsHelper

  def description
    I18n.t('.content_deleted')
  end
  
  # @deprecated tag_content form requires to call something in model (really?)
  def read_access_strings
    ''
  end

  def read_access_list
    access_list unless @accessors
    @accessors[:readers]
  end
  
  # @deprecated tag_content form requires to call something in model (really?)
  def find_access_strings
    ''
  end

  def find_access_list
    access_list unless @accessors
    @accessors[:finders]
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

  private
  
  def access_list
    # initialize empty arry to for result
    @accessors = {}
    # array for accessors with read access
    @accessors[:readers] = []
    # array for accessors with find access
    @accessors[:finders] = []
    
    # get accessors
    taggings = ActsAsTaggableOn::Tagging.find_all_by_taggable_id(id)


    if taggings
      taggings.each do |tagging|
        # skip to next tagging if wrong context
        next unless tagging.context == 'access'

        # refine result in reader and finder lists        
        if tagging.tagger_type == 'User'
          if tagging.tag.name == 'read'
            @accessors[:readers] << User.find(tagging.tagger_id)
          elsif tagging.tag.name == 'find'
            @accessors[:finders] << User.find(tagging.tagger_id)
          end
        elsif tagging.tagger_type == 'Group'
          if tagging.tag.name == 'read'
            @accessors[:readers] << Group.find(tagging.tagger_id)
          elsif tagging.tag.name == 'find'
            @accessors[:finders] << Group.find(tagging.tagger_id)
          end
        else
          #something is broken
          raise "No access for type: #{tagging.tagger_type}"
        end
      end
    end
  end

end
