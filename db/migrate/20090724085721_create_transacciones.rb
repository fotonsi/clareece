class CreateTransacciones < ActiveRecord::Migration
  def self.up
    create_table :transacciones do |t|
      t.string :concepto, :tipo
      t.text :observaciones
      t.float :importe
      t.boolean :domiciliar, :default => false

      t.timestamps
    end
  end

  def self.down
    drop_table :transacciones
  end
end
