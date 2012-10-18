class CreateTableContentsLocations < ActiveRecord::Migration
  def change
    create_table :contents_locations do |t|
      t.integer :content_id
      t.integer :location_id
    end
  end
end

