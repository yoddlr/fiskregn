class AdminsGroups < ActiveRecord::Migration
  def change
    create_table :admins_groups do |t|
      t.integer :admin_id
      t.integer :group_id
    end
  end
end
