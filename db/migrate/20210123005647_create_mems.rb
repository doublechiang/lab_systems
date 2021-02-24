class CreateMems < ActiveRecord::Migration[5.2]
  def change
    create_table :mems do |t|
      t.integer :inventory_id
      t.text :description
      t.text :product
      t.text :vendor
      t.text :physid
      t.text :serial
      t.text :slot
      t.text :size
      t.datetime :timestamp

    end
  end
end
