class CreateConnections < ActiveRecord::Migration[6.1]
  def change
    create_table :connections do |t|
      t.text :mac
      t.text :user
      t.text :pass
      t.text :ip
      t.datetime :tod
    end
  end
end
