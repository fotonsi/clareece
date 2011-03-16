class ChangeAttributesToTransacciones < ActiveRecord::Migration
  def self.up
    add_column :transacciones, :destinatarios, :string
    add_column :transacciones, :concepto_de, :string
    remove_column :transacciones, :domiciliar 
    remove_column :transacciones, :type
    remove_column :transacciones, :utilizar_saldo
    remove_column :transacciones, :forma_pago
  end

  def self.down
    add_column :transacciones, :forma_pago, :string
    add_column :transacciones, :utilizar_saldo, :boolean, :default => false
    add_column :transacciones, :type, :string
    add_column :transacciones, :domiciliar, :boolean, :default => false
    remove_column :transacciones, :concepto_de
    remove_column :transacciones, :destinatarios
  end
end
