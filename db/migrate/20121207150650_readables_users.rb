class ReadablesUsers < ActiveRecord::Migration
  def up
    create_table :readables_users do |t|
      t.references :readable, null: false
      t.references :user, null: false
    end
    add_index :readables_users, [:readable_id, :user_id], :unique => true
  end

  def down
    drop_table :readables_users
  end
end
