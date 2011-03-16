class CreateFacturaDetalles < ActiveRecord::Migration
  def self.up
    create_table :factura_detalles do |t|
      t.integer :factura_id, :concepto_id, :cantidad
      t.float :precio, :impuesto, :total
      t.timestamps
    end
  end

  def self.down
    drop_table :factura_detalles
  end
end
