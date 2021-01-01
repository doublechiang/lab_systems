class CreateSels < ActiveRecord::Migration[5.2]
  def change
    create_table :sels do |t|
      t.integer :system_id
      t.text :sel_record_id
      t.text :record_type
      t.datetime :timestamp
      t.text :generator_id
      t.text :evm_revision
      t.text :sensor_type
      t.text :sensor_number
      t.text :event_type
      t.text :event_direction
      t.text :event_data
      t.text :description
      t.text :manufactacturer_id
      t.text :oem_defined
      t.text :panic_string
    end
  end
end
