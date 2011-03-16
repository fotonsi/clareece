class CajaCuadresAddColumns < ActiveRecord::Migration
  def self.up
    add_column :caja_cuadres, :fecha, :datetime
    add_column :caja_cuadres, :saldo_anterior, :float
    add_column :caja_cuadres, :ingresos, :float
    add_column :caja_cuadres, :suma_ingresos, :float
    add_column :caja_cuadres, :pagos, :float
    add_column :caja_cuadres, :ingresado_bancos, :float
    add_column :caja_cuadres, :ingresado_datafono, :float
    add_column :caja_cuadres, :suma_pagos, :float
    rename_column :caja_cuadres, :total_caja, :saldo_caja
    remove_column :caja_cuadres, :total_movimientos
    add_column :caja_cuadres, :efectivo, :float
    add_column :caja_cuadres, :vales, :float
    add_column :caja_cuadres, :cheques, :float
    add_column :caja_cuadres, :total_detalle, :float
    add_column :caja_cuadres, :saldo, :float
    add_column :caja_cuadres, :observaciones, :text
  end

  def self.down
    remove_column :caja_cuadres, :observaciones
    remove_column :caja_cuadres, :saldo
    remove_column :caja_cuadres, :total_detalle
    remove_column :caja_cuadres, :cheques
    remove_column :caja_cuadres, :vales
    remove_column :caja_cuadres, :efectivo
    add_column :caja_cuadres, :total_movimientos, :float
    rename_column :caja_cuadres, :saldo_caja, :total_caja
    remove_column :caja_cuadres, :suma_pagos
    remove_column :caja_cuadres, :ingresado_datafono
    remove_column :caja_cuadres, :ingresado_bancos
    remove_column :caja_cuadres, :pagos
    remove_column :caja_cuadres, :suma_ingresos
    remove_column :caja_cuadres, :ingresos
    remove_column :caja_cuadres, :saldo_anterior
    remove_column :caja_cuadres, :fecha
  end
end
