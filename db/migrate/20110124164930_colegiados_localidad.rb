class ColegiadosLocalidad < ActiveRecord::Migration
  def self.up
    add_column :colegiados, :localidad, :string
    add_column :colegiados, :localidad_nacimiento, :string
    add_column :colegiados, :pais_residencia_id, :integer
    change_column :colegiados, :cod_postal, :string
  end

  def self.down
    change_column :colegiados, :cod_postal, :string, :limit => 5
    remove_column :colegiados, :pais_residencia_id
    remove_column :colegiados, :localidad_nacimiento
    remove_column :colegiados, :localidad
  end
end
