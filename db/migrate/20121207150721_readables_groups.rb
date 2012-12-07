class ReadablesGroups < ActiveRecord::Migration
  def up
    create_table :readables_groups do |t|
      t.references :readable, null: false
      t.references :group, null: false
    end
    add_index :readables_groups, [:readable_id, :group_id], :unique => true
  end

  def down
    drop_table :readables_groups
  end
end
