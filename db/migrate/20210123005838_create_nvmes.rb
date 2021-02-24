class CreateNvmes < ActiveRecord::Migration[5.2]
  def change
    create_table :nvmes do |t|
      t.integer :inventory_id
      t.text :model
      t.text :serial
      t.text :firmware_rev
      t.text :address
      t.datetime :timestamp
    end
  end
end
