class CreateTableContentsTopics < ActiveRecord::Migration
  def up
    # CREATE TABLE "contents_topics" (
    #    "id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    #    "content_id" integer NOT NULL,
    #    "topic_id" integer NOT NULL);
    #
    create_table :contents_topics  do |t|
      t.references :content, :null => false
      t.references :topic, :null => false
    end

    # CREATE UNIQUE INDEX "index_contents_topics_on_content_id_and_topic_id"
    #    ON "contents_topics" ("content_id", "topic_id");
    #
    add_index :contents_topics, [:content_id, :topic_id], :unique => true
  end

  def down
    drop_table :contents_topics
  end
end
