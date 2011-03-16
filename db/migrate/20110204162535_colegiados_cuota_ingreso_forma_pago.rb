class ColegiadosCuotaIngresoFormaPago < ActiveRecord::Migration
  def self.up
    add_column :colegiados, :cuota_ingreso_forma_pago, :string, :limit => 20
    Colegiado.connection.execute("update colegiados set cuota_ingreso_forma_pago = 'efectivo' where cuota_ingreso_efectivo is true;")
    remove_column :colegiados, :cuota_ingreso_efectivo
  end

  def self.down
    add_column :colegiados, :cuota_ingreso_efectivo, :boolean
    Colegiado.connection.execute("update colegiados set cuota_ingreso_efectivo = true where cuota_ingreso_forma_pago = 'efectivo';")
    remove_column :colegiados, :cuota_ingreso_forma_pago
  end
end
