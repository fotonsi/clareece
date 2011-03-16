class AddAttributesToCursos < ActiveRecord::Migration
  def self.up
    add_column :cursos, :num_plazas_max, :integer
    add_column :cursos, :num_plazas_min, :integer
    add_column :cursos, :descripcion, :string
  end

  def self.down
    remove_column :cursos, :descripcion
    remove_column :cursos, :num_plazas_min
    remove_column :cursos, :num_plazas_max
  end
end
