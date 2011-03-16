class AddAttributesToTransacciones5 < ActiveRecord::Migration
  def self.up
    remove_column :transacciones, :fecha
    add_column :transacciones, :fecha_cobro, :date
    add_column :transacciones, :fecha_generacion, :date
    add_column :transacciones, :generado, :boolean
  end

  def self.down
    remove_column :transacciones, :generado
    remove_column :transacciones, :fecha_generacion
    remove_column :transacciones, :fecha_cobro
    add_column :transacciones, :fecha, :datetime
  end
end
