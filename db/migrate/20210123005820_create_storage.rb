class CreateStorage < ActiveRecord::Migration[5.2]
  def change
    create_table :storages do |t|
      t.integer :inventory_id
      t.text :description
      t.text :product
      t.text :vendor
      t.text :businfo
      t.datetime :timestamp

    end
  end
end
