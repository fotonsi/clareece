class Transaccion < ActiveRecord::Base
  has_many 'movimientos', :as => 'origen', :dependent => :nullify, :order => 'id'

  validates_presence_of :concepto_de, :concepto, :importe, :destinatarios, :fecha_cobro
  validates_numericality_of :importe

  def validate
    if self.importe == 0
      self.errors.add :importe, "Debe ser distinto de 0"
    end
  end

  DESTINATARIOS = [:todos, :colegiados_domiciliaciones, :colegiados_caja]


  # Se crean sin generar los movimientos
  def initialize(*args)
    super
    self.generado = false
  end

  def to_label
    "#{concepto} (transacción)"
  end

  def importe_final
    movimientos.sum('importe', :conditions => 'fecha_anulacion is null and fecha_devolucion is null')
  end

  def generar!
    #Cargamos aquí el usuario que creó la transacción porque estamos en un proceso desatendido
    Thread.current[:current_user] = self.audits.first.user unless Thread.current[:current_user]
    generar_movimientos
    self.fecha_generacion = Date.today unless self.fecha_generacion
    self.generado = true
    self.save
  end

  def self.a_generar_hoy
    find(:all, :conditions => ['fecha_generacion = ? and generado is not true', Date.today])
  end

  def self.generar_pendientes!
    a_generar_hoy.each {|t| t.generar!}
  end

  def generacion_programada?
    !fecha_generacion.nil?
  end

  # Los movimientos se generar en un proceso desatendido
  def generar_movimientos
    Transaccion.transaction do
      conds = Colegiado.conds_exento_pago
      conds[0] = "not (#{conds[0]} or situacion_colegial = ?)"
      conds << 'baja_colegial'
      conds[0] << " and domiciliar_pagos is true" if destinatarios == 'colegiados_domiciliaciones'
      conds[0] << " and domiciliar_pagos is not true" if destinatarios == 'colegiados_caja'
      Colegiado.find(:all, :conditions => conds, :order => 'num_colegiado').each{|colegiado|
        begin
          m = Movimiento.create(:titular => colegiado, :origen => self,
                          :fecha => (Time.utc(fecha_cobro.year, fecha_cobro.month, fecha_cobro.day) if fecha_cobro),
                          :concepto_de => concepto_de,
                          :concepto => concepto, 
                          :forma_pago => forma_pago,
                          :caja => (Thread.current[:current_user].caja if Movimiento::FORMAS_PAGO_CAJA),
                          :importe => importe) 
          raise "Se produjo un error al guardar el movimiento, no se ha generado ninguno. El error es: #{m.errors.full_messages}" unless m.valid?
        rescue Exception => e
          raise "Se produjo un error al guardar el movimiento, no se ha generado ninguno. El error es: #{e.message}"
        end
      }
    end
  end


  # Authorized methods

  def authorized_for_edit?
    not generado?
  end

  def authorized_for_show?
    generado?
  end

  def authorized_for_generar?
    !new_record? && !generado?
  end

end
