class MembersGroups < ActiveRecord::Migration
  def change
    create_table :members_groups do |t|
      t.integer :member_id
      t.integer :group_id
    end
  end
end
