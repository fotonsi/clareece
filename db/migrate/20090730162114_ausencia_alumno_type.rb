class AusenciaAlumnoType < ActiveRecord::Migration
  def self.up
    add_column :ausencias, :alumno_type, :string
  end

  def self.down
    remove_column :ausencias, :alumno_type
  end
end
