class UsuariosPassword < ActiveRecord::Migration
  def self.up
    add_column :usuarios, :password, :string
  end

  def self.down
    remove_column :usuarios, :password
  end
end
