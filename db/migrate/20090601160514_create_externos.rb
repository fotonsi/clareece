class CreateExternos < ActiveRecord::Migration
  def self.up
    create_table :externos do |t|
      t.string :nombre, :apellido1, :apellido2, :nif
      t.timestamps
    end
  end

  def self.down
    drop_table :externos
  end
end
