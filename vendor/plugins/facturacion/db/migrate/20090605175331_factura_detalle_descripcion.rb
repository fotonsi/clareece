class FacturaDetalleDescripcion < ActiveRecord::Migration
  def self.up
    add_column :factura_detalles, :descripcion, :string
  end

  def self.down
    remove_column :factura_detalles, :descripcion
  end
end
