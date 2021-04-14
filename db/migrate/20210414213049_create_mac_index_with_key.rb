class CreateMacIndexWithKey < ActiveRecord::Migration[5.2]
  def change
    remove_index :systems, :bmc_mac
    add_index :systems, [:bmc_mac], :unique => true, length: 17
  end
end
