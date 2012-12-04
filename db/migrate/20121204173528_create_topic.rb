class CreateTopic < ActiveRecord::Migration
  def up
    # For the fun of it; the generated sql in sqlite:
    # CREATE TABLE "topics" (
    #   "id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    #   "name" varchar(255) NOT NULL);
    #
    create_table :topics do |t|
      t.string :name, :null => false
    end
  end

  def down
    drop_table :topics
  end
end
