class CreateDisks < ActiveRecord::Migration[5.2]
  def change
    create_table :disks do |t|
      t.integer :inventory_id
      t.text :description
      t.text :product
      t.text :version
      t.text :serial
      t.text :businfo
      t.datetime :timestamp

    end
  end
end
