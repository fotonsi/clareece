class ClientesCamposEmpresas < ActiveRecord::Migration
  def self.up
    add_column :clientes_clientes, :cif, :string
    add_column :clientes_clientes, :persona_responsable_id, :integer
  end

  def self.down
    remove_column :clientes_clientes, :persona_responsable_id
    remove_column :clientes_clientes, :cif
  end
end
