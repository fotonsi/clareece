class GestionDocumentalNumRegistro < ActiveRecord::Migration
  def self.up
    add_column :gestiones_documentales, :num_registro, :integer
  end

  def self.down
    remove_column :gestiones_documentales, :num_registro
  end
end
