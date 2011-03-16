class MovimientoAnulacionConFecha < ActiveRecord::Migration
  def self.up
    remove_column :movimientos, :anulado
    add_column :movimientos, :fecha_anulacion, :datetime
  end

  def self.down
    remove_column :movimientos, :fecha_anulacion
    add_column :movimientos, :anulado, :boolean
  end
end
