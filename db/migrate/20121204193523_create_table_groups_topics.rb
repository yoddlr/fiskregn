class CreateTableGroupsTopics < ActiveRecord::Migration
  def up
    # CREATE TABLE "groups_topics" (
    #    "id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    #    "group_id" integer NOT NULL,
    #    "topic_id" integer NOT NULL);
    #
    create_table :groups_topics  do |t|
      t.references :group, :null => false
      t.references :topic, :null => false
    end

    # CREATE UNIQUE INDEX "index_groups_topics_on_group_id_and_topic_id"
    #    ON "groups_topics" ("group_id", "topic_id");
    #
    add_index :groups_topics, [:group_id, :topic_id], :unique => true
  end

  def down
    drop_table :groups_topics
  end
end
