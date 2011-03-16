class CreateCursoProfesores < ActiveRecord::Migration
  def self.up
    create_table :curso_profesores do |t|
      t.integer :curso_id, :profesor_id
      t.timestamps
    end
  end

  def self.down
    drop_table :curso_profesores
  end
end
