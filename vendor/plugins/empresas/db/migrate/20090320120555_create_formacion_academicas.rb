class CreateFormacionAcademicas < ActiveRecord::Migration
  def self.up
    create_table :formacion_academicas do |t|
      t.string :titulacion
      t.date :fecha 
      t.integer :empleado_id
      t.timestamps
    end
  end

  def self.down
    drop_table :formacion_academicas
  end
end
