class CreateExpedientesGestiones < ActiveRecord::Migration
  def self.up
    create_table :expedientes_gestiones, :id => true do |t|
      t.references :expediente
      t.references :gestion_documental
      t.string :etiquetas
      t.timestamps
    end
  end

  def self.down
    drop_table :expedientes_gestiones
  end
end
