class ColegiosCuotaColegiacion < ActiveRecord::Migration
  def self.up
    add_column :colegios, :cuota_colegiacion, :float
    add_column :colegios, :cuota_colegiacion_num_plazos, :integer
  end

  def self.down
    remove_column :colegios, :cuota_colegiacion_num_plazos
    remove_column :colegios, :cuota_colegiacion
  end
end
