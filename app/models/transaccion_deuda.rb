class TransaccionDeuda < Transaccion

  private

  def generar_movimientos
    TransaccionDeuda.transaction do
      Colegiado.find(:all, :conditions => ["saldar_deuda = ? and domiciliar_pagos = ?", true, true]).each do |colegiado|
        # Se genera pago de deuda si el colegiado es deudor.
        if colegiado.deudor?
          importe = [(colegiado.importe_deuda || 0), colegiado.saldo.abs].min
          Movimiento.create(:tipo => tipo, :concepto => concepto, 
                            :importe => importe, :forma_pago => :domiciliacion.to_s,
                            :titular => colegiado, :origen => self)
        end
        # Se desactiva el pago de deuda si el colegiado ya no es deudor.
        if not colegiado.reload.deudor?
          colegiado.saldar_deuda = false
          colegiado.save
        end
      end
    end
  end

end
