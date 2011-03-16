class ColegiosFirmas < ActiveRecord::Migration
  def self.up
    add_column :colegios, :secretaria, :string
    add_column :colegios, :presidencia, :string
    add_column :colegios, :vicepresidencia, :string
    add_column :colegios, :tesoreria, :string
  end

  def self.down
    remove_column :colegios, :tesoreria
    remove_column :colegios, :vicepresidencia
    remove_column :colegios, :presidencia
    remove_column :colegios, :secretaria
  end
end
