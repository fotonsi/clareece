class FacturaNumero < ActiveRecord::Migration
  def self.up
    add_column :facturas, :numero, :integer
  end

  def self.down
    remove_column :facturas, :numero
  end
end
