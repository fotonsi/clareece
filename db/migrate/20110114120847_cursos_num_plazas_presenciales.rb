class CursosNumPlazasPresenciales < ActiveRecord::Migration
  def self.up
    add_column :cursos, :num_plazas_presenciales, :integer
  end

  def self.down
    remove_column :cursos, :num_plazas_presenciales
  end
end
