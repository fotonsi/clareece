class CreateClientesClientes < ActiveRecord::Migration
  def self.up
    create_table :clientes_clientes do |t|
      t.string :nombre, :direccion, :telefono1, :telefono2, :fax, :cc_aa, :email, :num_cuenta, :localidad_oficina, :titular_cuenta, :poblacion_banco, :type
      t.integer :localidad_id, :banco_id
      t.date :fecha_cambio_domicilio
      t.text :observaciones
      t.timestamps
    end
  end

  def self.down
    drop_table :clientes_clientes
  end
end
