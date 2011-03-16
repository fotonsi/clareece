class ColegiadosPeriodoExencionPago < ActiveRecord::Migration
  def self.up
    add_column :colegiados, :fecha_ini_exencion_pago, :date
    add_column :colegiados, :fecha_fin_exencion_pago, :date
  end

  def self.down
    remove_column :colegiados, :fecha_fin_exencion_pago
    remove_column :colegiados, :fecha_ini_exencion_pago
  end
end
