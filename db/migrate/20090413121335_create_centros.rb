class CreateCentros < ActiveRecord::Migration
  def self.up
    create_table :centros do |t|
      t.string :nombre
      t.timestamps
    end
  end

  def self.down
    drop_table :centros
  end
end
