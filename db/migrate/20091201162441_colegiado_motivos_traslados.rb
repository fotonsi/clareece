class ColegiadoMotivosTraslados < ActiveRecord::Migration
  def self.up
    add_column :colegiados, :motivo_ingreso, :string
    add_column :colegiados, :motivo_baja, :string
  end

  def self.down
    remove_column :colegiados, :motivo_baja
    remove_column :colegiados, :motivo_ingreso
  end
end
