class CreateTopics < ActiveRecord::Migration
  def up
    # For the fun of it; the generated sql in sqlite:
    # CREATE TABLE "topics" (
    #    "id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    #    "name" varchar(255) NOT NULL,
    #    "place_id" integer NOT NULL,
    #    "topic_id" integer NOT NULL);
    #
    create_table :topics do |t|
      t.string :name, :null => false
      t.references :place, :null => false
      t.references :topic, :null => false
    end

    # CREATE UNIQUE INDEX "index_topics_on_place_id_and_topic_id" ON "topics" ("place_id", "topic_id");
    #
    add_index :topics, [:place_id, :topic_id], :unique => true
  end

  def down
    drop_table :topics
  end
end
