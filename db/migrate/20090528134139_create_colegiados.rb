class CreateColegiados < ActiveRecord::Migration
  def self.up
    create_table :colegiados do |t|
      t.string :nombre, :apellido1, :apellido2, :nif, :direccion, :telefono1, :telefono2, :telefono_trabajo, :fax, :cc_aa, :email, :num_cuenta, :oficina, :titular_cuenta, :poblacion_banco, :type, :procedencia, :destino, :ref_historial
      t.integer :localidad_id, :banco_id, :profesion_id, :num_colegiado, :centro_id
      t.date :fecha_nacimiento, :fecha_cambio_domicilio, :fecha_ingreso, :fecha_baja
      t.boolean :no_ejerciente, :jubilado
      t.string :sexo, :limit => 1
      t.text :observaciones
      t.timestamps
    end
  end

  def self.down
    drop_table :colegiados
  end
end
