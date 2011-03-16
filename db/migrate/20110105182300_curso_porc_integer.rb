class CursoPorcInteger < ActiveRecord::Migration
  def self.up
    change_column :cursos, :porc_asistencia_minima, :integer
  end

  def self.down
    change_column :cursos, :porc_asistencia_minima, :float
  end
end
