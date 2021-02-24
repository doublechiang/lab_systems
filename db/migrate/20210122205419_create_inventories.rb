class CreateInventories < ActiveRecord::Migration[5.2]
  def change
    create_table :inventories do |t|
      t.text :bmc_mac
    end
  end
  # add_index :inventories, :bmc_mac, unique: true
end
