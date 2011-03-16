class ChangeAttributesToCursos < ActiveRecord::Migration
  def self.up
    change_column :cursos, :fecha_limite_matricula, :datetime
    change_column :cursos, :fecha_limite_devolucion, :datetime
    remove_column :cursos, :hora_limite_matricula
    remove_column :cursos, :hora_limite_devolucion
  end

  def self.down
    add_column :cursos, :hora_limite_devolucion, :string
    add_column :cursos, :hora_limite_matricula, :string
    change_column :cursos, :fecha_limite_devolucion, :date
    change_column :cursos, :fecha_limite_matricula, :date
  end
end
