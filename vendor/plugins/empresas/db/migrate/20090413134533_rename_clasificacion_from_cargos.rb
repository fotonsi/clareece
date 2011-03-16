class RenameClasificacionFromCargos < ActiveRecord::Migration
  def self.up
    rename_column :cargos, :clasificacion, :calificacion
  end

  def self.down
    rename_column :cargos, :calificacion, :clasificacion
  end
end

