class AddProductToInventories < ActiveRecord::Migration[5.2]
  def change
    add_column :inventories, :product, :text
  end
end
