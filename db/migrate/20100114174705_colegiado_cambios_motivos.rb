class ColegiadoCambiosMotivos < ActiveRecord::Migration
  def self.up
    remove_column :colegiados, :motivo_ingreso
    add_column :colegiados, :motivo_ingreso_id, :integer
    remove_column :colegiados, :motivo_baja
    add_column :colegiados, :motivo_baja_id, :integer
  end

  def self.down
    remove_column :colegiados, :motivo_baja_id
    add_column :colegiados, :motivo_baja, :string
    remove_column :colegiados, :motivo_ingreso_id
    add_column :colegiados, :motivo_ingreso, :string
  end
end
