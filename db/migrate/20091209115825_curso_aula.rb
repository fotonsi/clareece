class CursoAula < ActiveRecord::Migration
  def self.up
    remove_column :cursos, :lugar
    add_column :cursos, :aula_id, :integer
  end

  def self.down
    remove_column :cursos, :aula_id
    add_column :cursos, :lugar, :string
  end
end
