class PermisosRoles < ActiveRecord::Migration
  def self.up
   create_table :permisos_roles, :id => false, :force => true do |t|
      t.references :permiso
      t.references :rol
    end
  end

  def self.down
    drop_table :permisos_roles
  end
end
