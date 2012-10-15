class AddParentIfToContents < ActiveRecord::Migration
  def change
    add_column :contents, :parent_id, :integer
  end
end
