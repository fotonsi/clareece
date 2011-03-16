class CreateAusencias < ActiveRecord::Migration
  def self.up
    create_table :ausencias do |t|
      t.string :turno
      t.integer :alumno_id, :curso_id
      t.date :fecha
      t.timestamps
    end
  end

  def self.down
    drop_table :ausencias
  end
end
