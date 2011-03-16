class CreateSedes < ActiveRecord::Migration
  def self.up
    create_table :sedes do |t|
      t.string :nombre, :direccion, :telefono1, :telefono2, :telefono3, :fax, :cif
      t.integer :localidad_id, :numero_gestor, :persona_responsable_id, :empresa_id

      t.timestamps
    end
  end

  def self.down
    drop_table :sedes
  end
end
