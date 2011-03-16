class CreateEspecialidades < ActiveRecord::Migration
  def self.up
    create_table :especialidades do |t|
      t.string :nombre
      t.integer :profesion_id
      t.timestamps
    end
  end

  def self.down
    drop_table :especialidades
  end
end
