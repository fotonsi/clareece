class ChangeGestionesDocumentales < ActiveRecord::Migration
  def self.up
    remove_column :gestiones_documentales, :remitente 
    remove_column :gestiones_documentales, :destinatario_pase
    remove_column :gestiones_documentales, :pase
    remove_column :gestiones_documentales, :fecha_pase
    remove_column :gestiones_documentales, :descripcion
    add_column :gestiones_documentales, :texto, :text
  end

  def self.down
    remove_column :gestiones_documentales, :texto
    add_column :gestiones_documentales, :descripcion, :text
    add_column :gestiones_documentales, :fecha_pase, :datetime
    add_column :gestiones_documentales, :pase, :boolean
    add_column :gestiones_documentales, :destinatario_pase, :string
    add_column :gestiones_documentales, :remitente, :string
  end
end
