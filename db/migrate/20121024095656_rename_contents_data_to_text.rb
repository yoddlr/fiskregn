# Bringing the data field in line with what it specifically contains
class RenameContentsDataToText < ActiveRecord::Migration
  def up
    rename_column :contents, :data, :text
  end

  def down
    rename_column :contents, :text, :data
  end
end
