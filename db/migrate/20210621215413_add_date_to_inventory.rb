class AddDateToInventory < ActiveRecord::Migration[5.2]
  def change
    add_column :inventories, :timestamp, :timestamp
  end
end
