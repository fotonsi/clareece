namespace :app do
  
  desc "Genera datos iniciales necesarios"
  task :initializer => :environment do
    # Genera colegio de la aplicación
    Colegio.create Colegio::DEFAULTS.merge(:actual => true) if Colegio.first.nil?
    
    Colegiado.all.each{|colegiado|
      # Asigna un expediente a cada colegiado
      if colegiado.expediente.nil?
        colegiado.expediente = Expediente.create(:titulo => "Expediente colegiado")
      end

      # Se marca los titulares de cuenta
      colegiado.titular_cuenta = colegiado.nombre_titular_cuenta.blank?
      
      colegiado.save
    }
  end

  desc "Se genera transacción bancaria para saldar deuda"
  task :saldar_deuda => :environment do
    TransaccionDeuda.create(:tipo => :abono.to_s, 
                            :importe => 0, 
                            :domiciliar => true,
                            :concepto => "Saldar deuda Colegio profesional de ...")
  end

  desc "Genera las transacciones correspondientes"
  task :generar_transacciones => :environment do
    msj = {}
    msj[:asunto] = I18n.t("notificador.transaccion.asunto") 
    Transaccion.find(:all, :conditions => {:fecha_generacion => Date.today}).each do |transaccion|
      if transaccion.generar!
        msj[:contenido] = I18n.t("notificador.transaccion.success", 
                                 :id => remesa.id,
                                 :concepto => transaccion.concepto, 
                                 :fecha_cobro => transaccion.fecha_cobro,
                                 :fecha_generacion => transaccion.fecha_generacion,
                                 :importe  => transaccion.importe,
                                 :importe_final => transaccion.importe_final, 
                                 :num_movimientos => transaccion.movimientos.count)    
      else
        msj[:contenido] = I18n.t("notificador.transaccion.error", 
                                 :id => remesa.id,
                                 :concepto => transaccion.concepto,
                                 :fecha_cobro => transaccion.fecha_cobro,
                                 :fecha_generacion => transaccion.fecha_generacion,
                                 :importe  => transaccion.importe)
      end
      Notificador.deliver_mensaje_servidor(msj[:asunto], msj[:contenido], Colegio.actual.contabilidad_email)
    end
  end

  desc "Genera los recibos de las remesas"
  task :generar_remesas => :environment do
    msj = {}
    msj[:asunto] = I18n.t("notificador.remesa.generar.asunto") 
    Remesa.find(:all, :conditions => {:estado => :sin_generar.to_s, :fecha_generacion => Date.today}).each do |remesa|
      if remesa.generar!
        msj[:contenido] = I18n.t("notificador.remesa.generar.success", 
                                 :id => remesa.id,
                                 :concepto => remesa.concepto, 
                                 :fecha_cobro => remesa.fecha_cobro,
                                 :fecha_generacion => remesa.fecha_generacion,
                                 :importe  => remesa.importe_total,
                                 :importe_final => remesa.importe_final, 
                                 :num_recibos => remesa.recibos.count)    
      else
        msj[:contenido] = I18n.t("notificador.remesa.generar.error", 
                                 :id => remesa.id,
                                 :concepto => remesa.concepto,
                                 :fecha_cobro => remesa.fecha_cobro,
                                 :fecha_generacion => remesa.fecha_generacion,
                                 :importe  => remesa.importe_total)
      end
      Notificador.deliver_mensaje_servidor(msj[:asunto], msj[:contenido], Colegio.actual.contabilidad_email)
    end
  end

  desc "Genera los movimientos de los recibos de las remesas"
  task :entregar_remesas => :environment do
    msj = {}
    msj[:asunto] = I18n.t("notificador.remesa.entregar.asunto") 
    Remesa.find(:all, :conditions => {:estado => :generado.to_s, :fecha_entrega => Date.today}).each do |remesa| 
      if remesa.entregar!
        msj[:contenido] = I18n.t("notificador.remesa.entregar.success", 
                                 :id => remesa.id,
                                 :concepto => remesa.concepto, 
                                 :fecha_cobro => remesa.fecha_cobro,
                                 :fecha_entrega => remesa.fecha_entrega,
                                 :importe  => remesa.importe_total,
                                 :importe_final => remesa.importe_final, 
                                 :num_movimientos => remesa.num_movimientos)    
      else
        msj[:contenido] = I18n.t("notificador.remesa.entregar.error", 
                                 :id => remesa.id,
                                 :concepto => remesa.concepto,
                                 :fecha_cobro => remesa.fecha_cobro,
                                 :fecha_entrega => remesa.fecha_entrega,
                                 :importe  => remesa.importe_total)
      end
      Notificador.deliver_mensaje_servidor(msj[:asunto], msj[:contenido], Colegio.actual.contabilidad_email)
    end
  end

  desc "Genera movimientos de anulación de los movimientos de los recibos de las remesas"
  task :anular_remesas => :environment do
    msj = {}
    msj[:asunto] = I18n.t("notificador.remesa.anular.asunto") 
    Remesa.find(:all, :conditions => {:estado => :entregado.to_s, :fecha_anulacion => Date.today}).each do |remesa|
      if remesa.anular!
        msj[:contenido] = I18n.t("notificador.remesa.anular.success", 
                                 :id => remesa.id,
                                 :concepto => remesa.concepto, 
                                 :fecha_cobro => remesa.fecha_cobro,
                                 :fecha_anulacion => remesa.fecha_anulacion,
                                 :importe  => remesa.importe_total)
      else
        msj[:contenido] = I18n.t("notificador.remesa.anular.error", 
                                 :id => remesa.id,
                                 :concepto => remesa.concepto,
                                 :fecha_cobro => remesa.fecha_cobro,
                                 :fecha_anulacion => remesa.fecha_anulacion,
                                 :importe  => remesa.importe_total)
      end
      Notificador.deliver_mensaje_servidor(msj[:asunto], msj[:contenido], Colegio.actual.contabilidad_email)
    end
  end

end
