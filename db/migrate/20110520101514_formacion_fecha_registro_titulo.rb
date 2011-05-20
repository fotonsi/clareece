class FormacionFechaRegistroTitulo < ActiveRecord::Migration
  def self.up
    add_column :formaciones, :fecha_registro_titulo, :date
  end

  def self.down
    remove_column :formaciones, :fecha_registro_titulo
  end
end
