class FacturaDetalleNumero < ActiveRecord::Migration
  def self.up
    add_column :factura_detalles, :numero, :integer
  end

  def self.down
    remove_column :factura_detalles, :numero
  end
end
