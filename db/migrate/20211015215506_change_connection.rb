class ChangeConnection < ActiveRecord::Migration[ 5.2]
  def change
    add_column :connections, :system_id, :integer
    add_foreign_key :connection, :systems
  
  end
end
