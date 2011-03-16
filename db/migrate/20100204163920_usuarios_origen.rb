class UsuariosOrigen < ActiveRecord::Migration
  def self.up
    add_column :usuarios, :origen_type, :string
    add_column :usuarios, :origen_id, :integer
  end

  def self.down
    remove_column :usuarios, :origen_id
    remove_column :usuarios, :origen_type
  end
end
