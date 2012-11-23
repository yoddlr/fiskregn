class MakeLocationsTablePolymorphicAddingGroupsToUsers < ActiveRecord::Migration
  def up

    change_table :locations do |t|
      t.rename :user_id, :owner_id
      t.string :owner_type
    end
    
    # Add type to users currently in table
    Location.all.each do |l|
      l.owner_type = 'User'
      l.save
    end
  end

  def down

    # Remove all rows for groups
    Location.all.each do |l|
      l.destroy if l.owner_type == 'Group'
    end


    change_table :locations do |t|
      t.remove :owner_type
      t.rename :owner_id, :user_id
    end
  end
end
