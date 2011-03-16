class CreateExpedientes < ActiveRecord::Migration
  def self.up
    create_table :expedientes do |t|
      t.string :titulo
      t.text :descripcion
      t.date :fecha_apertura, :fecha_cierre

      t.timestamps
    end
  end

  def self.down
    drop_table :expedientes
  end
end
