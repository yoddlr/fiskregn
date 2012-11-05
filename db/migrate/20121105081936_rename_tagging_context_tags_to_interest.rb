class RenameTaggingContextTagsToInterest < ActiveRecord::Migration
  def up
    ActsAsTaggableOn::Tagging.all.each do |tagging|
      if tagging.context == 'tags'
        tagging.context = 'interest'
        tagging.save
      end
    end
  end

  def down
    ActsAsTaggableOn::Tagging.all.each do |tagging|
      if tagging.context == 'interest'
        tagging.context = 'tags'
        tagging.save
      end
    end
  end
end
