class CreateProfesores < ActiveRecord::Migration
  def self.up
    create_table :profesores do |t|
      t.string :nombre, :apellido1, :apellido2, :nif, :telefono, :movil
      t.timestamps
    end
  end

  def self.down
    drop_table :profesores
  end
end
