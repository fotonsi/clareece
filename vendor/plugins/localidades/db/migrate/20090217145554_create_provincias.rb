class CreateProvincias < ActiveRecord::Migration
  def self.up
    create_table :provincias do |t|
      t.string :nombre
      t.integer :pais_id

      t.timestamps
    end
  end

  def self.down
    drop_table :provincias
  end
end
