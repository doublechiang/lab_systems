class CreateSystems < ActiveRecord::Migration[5.2]
  def change
    create_table :systems do |t|
      t.text :username
      t.text :password
      t.text :model
      t.text :comments
      t.text :bmc_mac
    end
    add_index :systems, [:bmc_mac], :unique => true, length: 17
  end
end