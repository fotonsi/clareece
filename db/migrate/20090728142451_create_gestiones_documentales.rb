class CreateGestionesDocumentales < ActiveRecord::Migration
  def self.up
    create_table :gestiones_documentales do |t|
      t.string :tipo, :responsable, :remitente, :destinatario, :destinatario_pase, :nombre_documento
      t.boolean :pase
      t.datetime :fecha_pase
      t.text :observaciones, :descripcion
      t.belongs_to :documento

      t.timestamps
    end
  end

  def self.down
    drop_table :gestiones_documentales
  end
end
