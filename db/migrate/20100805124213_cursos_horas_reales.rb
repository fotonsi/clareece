class CursosHorasReales < ActiveRecord::Migration
  def self.up
    add_column :cursos, :num_horas_presenciales, :float
    add_column :cursos, :num_horas_virtuales, :float
  end

  def self.down
    remove_column :cursos, :num_horas_virtuales
    remove_column :cursos, :num_horas_presenciales
  end
end
