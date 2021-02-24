class CreateNics < ActiveRecord::Migration[5.2]
  def change
    create_table :nics do |t|
      t.integer :inventory_id
      t.text :product
      t.text :vendor
      t.text :physid
      t.text :serial
      t.text :businfo
      t.datetime :timestamp
    end

  end
end
