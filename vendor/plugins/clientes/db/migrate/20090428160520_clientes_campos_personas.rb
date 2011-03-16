class ClientesCamposPersonas < ActiveRecord::Migration
  def self.up
    add_column :clientes_clientes, :apellido1, :string
    add_column :clientes_clientes, :apellido2, :string
    add_column :clientes_clientes, :telefono_trabajo, :string
    add_column :clientes_clientes, :nif, :string
    add_column :clientes_clientes, :profesion_id, :integer
    add_column :clientes_clientes, :fecha_nacimiento, :date
    add_column :clientes_clientes, :sexo, :string, :limit => 1
  end

  def self.down
    remove_column :clientes_clientes, :sexo
    remove_column :clientes_clientes, :fecha_nacimiento
    remove_column :clientes_clientes, :profesion_id
    remove_column :clientes_clientes, :nif
    remove_column :clientes_clientes, :telefono_trabajo
    remove_column :clientes_clientes, :apellido2
    remove_column :clientes_clientes, :apellido1
  end
end
