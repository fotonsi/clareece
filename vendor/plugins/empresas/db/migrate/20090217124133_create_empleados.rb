class CreateEmpleados < ActiveRecord::Migration
  def self.up
    create_table :empleados do |t|
      t.string :nombre, :apellido1, :apellido2, :direccion, :telefono1, :telefono2, :telefono3, :nif
      t.integer :localidad_id, :sede_id

      t.timestamps
    end
  end

  def self.down
    drop_table :empleados
  end
end
