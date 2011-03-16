class CreateFacturas < ActiveRecord::Migration
  def self.up
    create_table :facturas do |t|
      t.string :cliente_type, :origen_type
      t.integer :cliente_id, :origen_id
      t.float :importe, :impuesto, :total
      t.datetime :fecha
      t.timestamps
    end
  end

  def self.down
    drop_table :facturas
  end
end
