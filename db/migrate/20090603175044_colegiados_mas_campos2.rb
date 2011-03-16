class ColegiadosMasCampos2 < ActiveRecord::Migration
  def self.up
    add_column :colegiados, :localidad_nacimiento_id, :integer
    add_column :colegiados, :nacionalidad, :string
    add_column :colegiados, :grado_carrera, :string
    add_column :colegiados, :situacion_profesional, :string
    add_column :colegiados, :ejercicio_profesional, :string
  end

  def self.down
    remove_column :colegiados, :ejercicio_profesional
    remove_column :colegiados, :situacion_profesional
    remove_column :colegiados, :grado_carrera
    remove_column :colegiados, :nacionalidad
    remove_column :colegiados, :localidad_nacimiento_id
  end
end
