class CreateFormacionEspecificas < ActiveRecord::Migration
  def self.up
    create_table :formacion_especificas do |t|
      t.string :nombre
      t.string :centro
      t.date :fecha
      t.integer :empleado_id
      t.timestamps
    end
  end

  def self.down
    drop_table :formacion_especificas
  end
end
