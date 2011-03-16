class CreateColegiadoProfesiones < ActiveRecord::Migration
  def self.up
    create_table :colegiado_profesiones do |t|
      t.integer :colegiado_id, :profesion_id
      t.timestamps
    end
  end

  def self.down
    drop_table :colegiado_profesiones
  end
end
