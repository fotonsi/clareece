class CreateClienteObjetos < ActiveRecord::Migration
  def self.up
    create_table :cliente_objetos do |t|
      t.string :cliente_type, :objeto_type
      t.integer :cliente_id, :objeto_id

      t.timestamps
    end
  end

  def self.down
    drop_table :cliente_objetos
  end
end
