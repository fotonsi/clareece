class AddAttributesToCursos2 < ActiveRecord::Migration
  def self.up
    add_column :cursos, :estado, :string
  end

  def self.down
    remove_column :cursos, :estado
  end
end
