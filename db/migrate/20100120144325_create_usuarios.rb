class CreateUsuarios < ActiveRecord::Migration
  def self.up
    create_table :usuarios do |t|
      t.string :login, :nombre, :apellido1, :apellido2, :rol
      t.timestamps
    end
  end

  def self.down
    drop_table :usuarios
  end
end
