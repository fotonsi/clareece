class MovimientosDevolucionDe < ActiveRecord::Migration
  def self.up
    add_column :movimientos, :devolucion_de_id, :integer
  end

  def self.down
    remove_column :movimientos, :devolucion_de_id
  end
end
