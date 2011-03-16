class MovimientosFechaDevolucion < ActiveRecord::Migration
  def self.up
    add_column :movimientos, :fecha_devolucion, :datetime
  end

  def self.down
    remove_column :movimientos, :fecha_devolucion
  end
end
