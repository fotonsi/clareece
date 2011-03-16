class GestionDocumentalMasCampos < ActiveRecord::Migration
  def self.up
    add_column :gestiones_documentales, :remitente, :string
    add_column :gestiones_documentales, :direccion_remitente, :text
    add_column :gestiones_documentales, :direccion_destinatario, :text
  end

  def self.down
    remove_column :gestiones_documentales, :direccion_destinatario
    remove_column :gestiones_documentales, :direccion_remitente
    remove_column :gestiones_documentales, :remitente
  end
end
