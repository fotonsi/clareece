class AddAttributesToTransacciones < ActiveRecord::Migration
  def self.up
    add_column :transacciones, :type, :string
  end

  def self.down
    remove_column :transacciones, :type
  end
end
