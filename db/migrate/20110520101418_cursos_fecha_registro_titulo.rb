class CursosFechaRegistroTitulo < ActiveRecord::Migration
  def self.up
    add_column :cursos, :fecha_registro_titulo, :date
  end

  def self.down
    remove_column :cursos, :fecha_registro_titulo
  end
end
