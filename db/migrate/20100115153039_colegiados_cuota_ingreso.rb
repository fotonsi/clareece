class ColegiadosCuotaIngreso < ActiveRecord::Migration
  def self.up
    add_column :colegiados, :cuota_ingreso_efectivo, :boolean
  end

  def self.down
    remove_column :colegiados, :cuota_ingreso_efectivo
  end
end
