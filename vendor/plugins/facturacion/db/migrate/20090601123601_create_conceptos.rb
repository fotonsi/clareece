class CreateConceptos < ActiveRecord::Migration
  def self.up
    create_table :conceptos do |t|
      t.string :descripcion, :codigo, :objeto_type, :origen_type
      t.integer :objeto_id, :origen_id
      t.timestamps
    end
  end

  def self.down
    drop_table :conceptos
  end
end
