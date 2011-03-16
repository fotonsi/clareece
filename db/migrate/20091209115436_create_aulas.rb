class CreateAulas < ActiveRecord::Migration
  def self.up
    create_table :aulas do |t|
      t.string :nombre
      t.integer :capacidad
      t.timestamps
    end
  end

  def self.down
    drop_table :aulas
  end
end
