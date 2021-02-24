class CreateCpus < ActiveRecord::Migration[5.2]
  def change
    create_table :cpus do |t|
      t.integer :inventory_id
      t.text :product
      t.text :slot
      t.datetime :timestamp

    end
  end
end
