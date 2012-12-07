# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20121207163206) do

  create_table "admins_groups", :force => true do |t|
    t.integer "admin_id"
    t.integer "group_id"
  end

  create_table "contents", :force => true do |t|
    t.string   "text"
    t.integer  "user_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "parent_id"
    t.string   "type"
  end

  create_table "contents_locations", :force => true do |t|
    t.integer "content_id"
    t.integer "location_id"
  end

  create_table "contents_topics", :force => true do |t|
    t.integer "content_id", :null => false
    t.integer "topic_id",   :null => false
  end

  add_index "contents_topics", ["content_id", "topic_id"], :name => "index_contents_topics_on_content_id_and_topic_id", :unique => true

  create_table "groups", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "groups_topics", :force => true do |t|
    t.integer "group_id", :null => false
    t.integer "topic_id", :null => false
  end

  add_index "groups_topics", ["group_id", "topic_id"], :name => "index_groups_topics_on_group_id_and_topic_id", :unique => true

  create_table "locations", :force => true do |t|
    t.integer "owner_id"
    t.string  "owner_type"
  end

  create_table "locations_publish_groups", :force => true do |t|
    t.integer "location_id",      :null => false
    t.integer "publish_group_id", :null => false
  end

  create_table "locations_publishers", :force => true do |t|
    t.integer "location_id",  :null => false
    t.integer "publisher_id", :null => false
  end

  add_index "locations_publishers", ["location_id", "publisher_id"], :name => "index_locations_publishers_on_location_id_and_publisher_id", :unique => true

  create_table "locs_pub_groups", :force => true do |t|
    t.integer "location_id",      :null => false
    t.integer "publish_group_id", :null => false
  end

  add_index "locs_pub_groups", ["location_id", "publish_group_id"], :name => "index_locs_pub_groups_on_location_id_and_publish_group_id", :unique => true

  create_table "members_groups", :force => true do |t|
    t.integer "member_id"
    t.integer "group_id"
  end

  create_table "readables_groups", :force => true do |t|
    t.integer "readable_id", :null => false
    t.integer "group_id",    :null => false
  end

  add_index "readables_groups", ["readable_id", "group_id"], :name => "index_readables_groups_on_readable_id_and_group_id", :unique => true

  create_table "readables_users", :force => true do |t|
    t.integer "readable_id", :null => false
    t.integer "user_id",     :null => false
  end

  add_index "readables_users", ["readable_id", "user_id"], :name => "index_readables_users_on_readable_id_and_user_id", :unique => true

  create_table "taggings", :force => true do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type"
    t.integer  "tagger_id"
    t.string   "tagger_type"
    t.string   "context",       :limit => 128
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id"], :name => "index_taggings_on_tag_id"
  add_index "taggings", ["taggable_id", "taggable_type", "context"], :name => "index_taggings_on_taggable_id_and_taggable_type_and_context"

  create_table "tags", :force => true do |t|
    t.string "name"
  end

  create_table "topics", :force => true do |t|
    t.string "name", :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
