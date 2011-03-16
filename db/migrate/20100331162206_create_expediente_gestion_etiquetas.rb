class CreateExpedienteGestionEtiquetas < ActiveRecord::Migration
  def self.up
    create_table :expediente_gestion_etiquetas do |t|
      t.integer :expediente_gestion_id
      t.string :etiqueta
      t.timestamps
    end
    remove_column :expedientes_gestiones, :etiquetas
  end

  def self.down
    add_column :expedientes_gestiones, :etiquetas, :string
    drop_table :expediente_gestion_etiquetas
  end
end
