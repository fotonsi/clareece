class CreateClientesContactos < ActiveRecord::Migration
  def self.up
    create_table :clientes_contactos do |t|
      t.string :padre_type, :nombre, :apellido1, :apellido2, :nif, :telefono1, :telefono2, :email, :fax
      t.integer :padre_id
      t.text :observaciones
      t.timestamps
    end
  end

  def self.down
    drop_table :clientes_contactos
  end
end
