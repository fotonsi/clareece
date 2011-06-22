class ExpedientesVisibleUsuarios < ActiveRecord::Migration
  def self.up
    add_column :expedientes, :visible_usuarios, :boolean
  end

  def self.down
    remove_column :expedientes, :visible_usuarios
  end
end
