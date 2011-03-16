class CreatePrecios < ActiveRecord::Migration
  def self.up
    create_table :precios do |t|
      t.string :origen_type, :cliente_type
      t.integer :origen_id, :cliente_id, :concepto_id, :impuesto_id, :cantidad_min, :cantidad_max
      t.float :precio
      t.timestamps
    end
  end

  def self.down
    drop_table :precios
  end
end
