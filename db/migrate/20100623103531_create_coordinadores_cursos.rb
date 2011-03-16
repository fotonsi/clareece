class CreateCoordinadoresCursos < ActiveRecord::Migration
  def self.up
    create_table :coordinadores do |t|
      t.string :nombre, :apellido1, :apellido2, :nif, :telefono, :movil
      t.timestamps
    end
    create_table :curso_coordinadores do |t|
      t.integer :curso_id, :coordinador_id
      t.timestamps
    end
  end

  def self.down
    drop_table :curso_coordinadores
    drop_table :coordinadores
  end
end
