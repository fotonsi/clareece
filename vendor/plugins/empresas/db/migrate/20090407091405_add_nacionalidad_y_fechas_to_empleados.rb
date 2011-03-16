class AddNacionalidadYFechasToEmpleados < ActiveRecord::Migration
  def self.up
    add_column :empleados, :nacionalidad, :string
    add_column :empleados, :fecha_alta, :date
    add_column :empleados, :fecha_baja, :date
  end

  def self.down
    remove_column :empleados, :nacionalidad
    remove_column :empleados, :fecha_alta
    remove_column :empleados, :fecha_baja
  end
end
