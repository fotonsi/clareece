class CursosNumHoras < ActiveRecord::Migration
  def self.up
    add_column :cursos, :num_horas, :float
  end

  def self.down
    remove_column :cursos, :num_horas
  end
end
