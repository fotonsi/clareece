class AddAttributesToMovimientos5 < ActiveRecord::Migration
  def self.up
    add_column :movimientos, :anulado, :boolean
  end

  def self.down
    remove_column :movimientos, :anulado
  end
end
