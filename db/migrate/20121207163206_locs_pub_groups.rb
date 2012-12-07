class LocsPubGroups < ActiveRecord::Migration
  def up
    create_table :locs_pub_groups do |t|
      t.references :location, null: false
      t.references :publish_group, null: false
    end
    add_index :locs_pub_groups, [:location_id, :publish_group_id], :unique => true
  end

  def down
    drop_table :locs_pub_groups
  end
end
