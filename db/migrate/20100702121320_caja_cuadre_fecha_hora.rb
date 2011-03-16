class CajaCuadreFechaHora < ActiveRecord::Migration
  def self.up
    change_column :caja_cuadres, :fecha, :datetime
  end

  def self.down
    change_column :caja_cuadres, :fecha, :date
  end
end
