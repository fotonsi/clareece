class CursoFechaIniMatricula < ActiveRecord::Migration
  def self.up
    add_column :cursos, :fecha_inicio_matricula, :datetime
  end

  def self.down
    remove_column :cursos, :fecha_inicio_matricula
  end
end
