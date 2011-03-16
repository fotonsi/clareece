class CreateClientesAgrupaciones < ActiveRecord::Migration
  def self.up
    create_table :clientes_agrupaciones do |t|
      t.integer :clientes_cliente_individual_id, :clientes_cliente_grupo_id
      t.timestamps
    end
  end

  def self.down
    drop_table :clientes_agrupaciones
  end
end
