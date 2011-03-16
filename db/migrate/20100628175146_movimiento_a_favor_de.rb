class MovimientoAFavorDe < ActiveRecord::Migration
  def self.up
    add_column :movimientos, :a_favor_de, :string
  end

  def self.down
    remove_column :movimientos, :a_favor_de
  end
end
