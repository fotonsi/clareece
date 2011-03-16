class ColegiadoSociedadProfesional < ActiveRecord::Migration
  def self.up
    add_column :colegiados, :sociedad_profesional, :boolean
  end

  def self.down
    remove_column :colegiados, :sociedad_profesional
  end
end
