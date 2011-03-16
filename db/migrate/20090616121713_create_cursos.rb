class CreateCursos < ActiveRecord::Migration
  def self.up
    create_table :cursos do |t|
      t.string :codigo, :nombre, :lugar
      t.date :fecha_ini, :fecha_fin, :fecha_limite_matricula, :fecha_limite_devolucion
      t.string :hora_limite_matricula, :hora_limite_devolucion, :limit => 5
      t.text :temario, :observaciones
      t.float :precio_matricula
      t.timestamps
    end
    
    create_table :curso_horarios do |t|
      t.integer :curso_id
      t.date :fecha_ini, :fecha_fin
      t.string :hora_ini, :hora_fin, :limit => 5
    end
  end

  def self.down
    drop_table :curso_horarios
    drop_table :cursos
  end
end
