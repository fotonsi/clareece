class AddAttributesToTransacciones2 < ActiveRecord::Migration
  def self.up
    add_column :transacciones, :utilizar_saldo, :boolean, :default => false
  end

  def self.down
    remove_column :transacciones, :utilizar_saldo
  end
end
