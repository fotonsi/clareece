class CreateProfesiones < ActiveRecord::Migration
  def self.up
    create_table :profesiones do |t|
      t.string :nombre
      t.timestamps
    end
  end

  def self.down
    drop_table :profesiones
  end
end
