class CreateExperienciaProfesionales < ActiveRecord::Migration
  def self.up
    create_table :experiencia_profesionales do |t|
      t.string :empresa
      t.string :puesto_trabajo
      t.date :fecha_inicio
      t.string :tiempo_permanencia
      t.integer :empleado_id
      t.timestamps
    end
  end

  def self.down
    drop_table :experiencia_profesionales
  end
end
