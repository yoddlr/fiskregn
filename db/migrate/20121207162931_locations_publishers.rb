class LocationsPublishers < ActiveRecord::Migration
  def up
    create_table :locations_publishers do |t|
      t.references :location, null: false
      t.references :publisher, null: false
    end
    add_index :locations_publishers, [:location_id, :publisher_id], :unique => true
  end

  def down
    drop_table :locations_publishers
  end
end
