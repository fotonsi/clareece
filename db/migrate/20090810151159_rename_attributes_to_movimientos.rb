class RenameAttributesToMovimientos < ActiveRecord::Migration
  def self.up
    rename_column :movimientos, :devuelto, :activo
  end

  def self.down
    rename_column :movimientos, :activo, :devuelto
  end
end
