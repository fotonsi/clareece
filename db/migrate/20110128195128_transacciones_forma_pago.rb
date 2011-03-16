class TransaccionesFormaPago < ActiveRecord::Migration
  def self.up
    add_column :transacciones, :forma_pago, :string
  end

  def self.down
    remove_column :transacciones, :forma_pago
  end
end
