class ChangeAttributesToMovimientos3 < ActiveRecord::Migration
  def self.up
    add_column :movimientos, :fecha, :datetime
    remove_column :movimientos, :tipo
    remove_column :movimientos, :activo
  end

  def self.down
    add_column :movimientos, :activo, :boolean
    add_column :movimientos, :tipo, :string
    remove_column :movimientos, :fecha
  end
end
