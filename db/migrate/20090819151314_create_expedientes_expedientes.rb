class CreateExpedientesExpedientes < ActiveRecord::Migration
  def self.up
    create_table :expedientes_expedientes, :id => false do |t|
      t.integer :expediente_id, :expediente_relacion_id
      t.timestamps
    end
  end

  def self.down
    drop_table :expedientes_expedientes
  end
end
