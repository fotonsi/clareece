class CursosPorcAsistenciaMinima < ActiveRecord::Migration
  def self.up
    add_column :cursos, :porc_asistencia_minima, :float
  end

  def self.down
    remove_column :cursos, :porc_asistencia_minima
  end
end
