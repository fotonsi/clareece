class CajaCuadre < ActiveRecord::Base
  def to_label
    %|Cuadre de #{self.fecha.strftime('%d/%m/%Y %H:%M') if self.fecha}|
  end

  def cuadre_anterior
    CajaCuadre.find(:all, :order => 'fecha', :conditions => ['fecha < ?', (fecha || Time.now)]).reject {|cc| cc.id == id}.last
  end

  def saldo_cuadre_anterior
    cuadre_anterior.saldo_caja if cuadre_anterior
  end

  def fecha_cuadre_anterior
    cuadre_anterior.fecha if cuadre_anterior
  end

  def movs_ingresos_desde_cuadre_anterior
    f = (fecha || Time.now)
    f = Time.utc(f.year, f.month, f.day, f.hour, f.min) #Quitamos segundos porque el calendario de pantalla los quita.
    Movimiento.find(:all, :order => 'fecha', :conditions => ['fecha_anulacion is null and fecha >= ? and fecha < ? and forma_pago = ? and importe < 0', fecha_cuadre_anterior, f, 'efectivo'])
  end

  def ingresos_desde_cuadre_anterior
    movs_ingresos_desde_cuadre_anterior.inject(0) {|suma, m| suma+m.importe.abs}
  end

  def listar_ingresos
    movs_ingresos_desde_cuadre_anterior.map {|mov| mov.to_csv}.join("\n")
  end

  def movs_pagos_desde_cuadre_anterior
    f = (fecha || Time.now)
    f = Time.utc(f.year, f.month, f.day, f.hour, f.min) #Quitamos segundos porque el calendario de pantalla los quita.
    Movimiento.find(:all, :order => 'fecha', :conditions => ['fecha_anulacion is null and fecha >= ? and fecha < ? and forma_pago = ? and importe > 0', fecha_cuadre_anterior, f, 'efectivo'])
  end

  def pagos_desde_cuadre_anterior
    movs_pagos_desde_cuadre_anterior.inject(0) {|suma, m| suma+m.importe.abs}
  end

  def listar_pagos
    movs_pagos_desde_cuadre_anterior.map {|mov| mov.to_csv}.join("\n")
  end

end
