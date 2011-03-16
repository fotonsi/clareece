class AddAttributesToTransacciones4 < ActiveRecord::Migration
  def self.up
    add_column :transacciones, :fecha, :datetime
    remove_column :transacciones, :tipo
  end

  def self.down
    add_column :transacciones, :tipo, :string
    remove_column :transacciones, :fecha
  end
end
