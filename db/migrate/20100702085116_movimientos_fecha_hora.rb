class MovimientosFechaHora < ActiveRecord::Migration
  def self.up
    change_column :movimientos, :fecha, :datetime
  end

  def self.down
    change_column :movimientos, :fecha, :date
  end
end
