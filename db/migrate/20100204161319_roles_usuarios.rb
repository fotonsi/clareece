class RolesUsuarios < ActiveRecord::Migration
  def self.up
    create_table :roles_usuarios, :id => false, :force => true do |t|
      t.references :rol
      t.references :usuario
    end
  end

  def self.down
    drop_table :roles_usuarios
  end
end
