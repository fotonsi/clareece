class CreateAccidenteLaborales < ActiveRecord::Migration
  def self.up
    create_table :accidente_laborales do |t|
      t.date :fecha
      t.text :descripcion
      t.date :fecha_baja
      t.date :fecha_alta
      t.integer :empleado_id
      t.timestamps
    end
  end

  def self.down
    drop_table :accidente_laborales
  end
end
