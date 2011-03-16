class AddToEmpleados < ActiveRecord::Migration
  def self.up
    add_column :empleados, :sexo, :string
    add_column :empleados, :estado_civil, :string
    add_column :empleados, :numero_hijos, :integer
    add_column :empleados, :fecha_nacimiento, :date
    add_column :empleados, :email, :string
    
    add_column :empleados, :categoria_profesional, :string
    add_column :empleados, :grupo_cotizacion, :string
    add_column :empleados, :contrato, :string
    add_column :empleados, :direccion_centro_trabajo, :string
    add_column :empleados, :numero_ss, :integer
    add_column :empleados, :examen_medico_previo, :string
    add_column :empleados, :fecha_examen_medico, :date
    add_column :empleados, :minusvalia, :string
    add_column :empleados, :porcentaje_minusvalia, :integer
    add_column :empleados, :carnet_conducir, :string
    add_column :empleados, :idiomas, :string

    add_column :empleados, :observaciones, :text
  end

  def self.down
    remove_column :empleados, :sexo
    remove_column :empleados, :estado_civil
    remove_column :empleados, :numero_hijos
    remove_column :empleados, :fecha_nacimiento
    remove_column :empleados, :email
    
    remove_column :empleados, :categoria_profesional
    remove_column :empleados, :grupo_cotizacion
    remove_column :empleados, :contrato
    remove_column :empleados, :direccion_centro_trabajo
    remove_column :empleados, :numero_ss
    remove_column :empleados, :examen_medico_previo
    remove_column :empleados, :fecha_examen_medico
    remove_column :empleados, :minusvalia
    remove_column :empleados, :porcentaje_minusvalia
    remove_column :empleados, :carnet_conducir
    remove_column :empleados, :idiomas

    remove_column :empleados, :observaciones
  end
end
