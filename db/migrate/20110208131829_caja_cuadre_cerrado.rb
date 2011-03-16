class CajaCuadreCerrado < ActiveRecord::Migration
  def self.up
    add_column :caja_cuadres, :cerrado, :boolean
  end

  def self.down
    remove_column :caja_cuadres, :cerrado
  end
end
