class CreateTableLocationsTopics < ActiveRecord::Migration
  def up
    # CREATE TABLE "locations_topics" (
    #    "id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    #    "location_id" integer NOT NULL,
    #    "topic_id" integer NOT NULL);
    #
    create_table :locations_topics  do |t|
      t.references :location, :null => false
      t.references :topic, :null => false
    end

    # CREATE UNIQUE INDEX "index_locations_topics_on_location_id_and_topic_id"
    #    ON "locations_topics" ("location_id", "topic_id");
    #
    add_index :locations_topics, [:location_id, :topic_id], :unique => true
  end

  def down
    drop_table :locations_topics
  end
end
