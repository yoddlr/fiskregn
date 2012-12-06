module TopicsHelper

  # Provides class methods
  def self.included(object)
    object.extend(ClassMethods)
  end

  def add_topic(topic)
    self.topics << topic
  end

  def remove_topic(topic)
    self.topics.delete topic
  end

  def add_topic_by_name(topic_name)
    topic = Topic.find_by_name(topic_name)
    self.topics << topic
  end

  def remove_topic_by_name(topic_name)
    topic = Topic.find_by_name(topic_name)
    self.topics.delete topic
  end

  module ClassMethods
    def find_by_topic_name(topic_name)
      self.joins(:topics).where(:topics => {name: topic_name})
    end
  end
end
