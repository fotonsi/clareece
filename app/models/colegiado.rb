class Colegiado < ActiveRecord::Base
  belongs_to :centro
  belongs_to :expediente, :dependent => :destroy #Borramos el expediente de colegiado
  belongs_to :banco
  belongs_to :pais
  belongs_to :pais_residencia, :class_name => 'Pais'
  belongs_to :motivo_ingreso, :class_name => 'TipoProcedencia'
  belongs_to :motivo_baja, :class_name => 'TipoDestino'
  has_many :colegiado_profesiones, :dependent => :destroy
  has_many :colegiado_especialidades, :dependent => :destroy
  has_many :formaciones, :as => :alumno, :dependent => :destroy
  has_many :ausencias, :as => :alumno, :dependent => :destroy
  has_many :movimientos, :as => :titular, :dependent => :nullify, :order => 'id'
  has_many :recibos, :as => :titular, :dependent => :nullify, :order => 'id'
  #has_one :usuario, :as => :login, :dependent => :destroy

  #acts_as_audited

  validates_presence_of :nombre, :apellido1, :doc_identidad, :tipo_doc_identidad, :fecha_nacimiento, :pais, :direccion, :localidad, :fecha_ingreso, :if => Proc.new {|colegiado| colegiado.situacion_colegial && !colegiado.migrado}

  validates_presence_of :num_cuenta, :banco_id, :if => Proc.new {|colegiado| colegiado.situacion_colegial && !colegiado.migrado && colegiado.domiciliar_pagos}, :message => "Si elige domiciliar el pago debe indicar el banco y el número de cuenta"

  validates_presence_of :sexo, :if => Proc.new {|colegiado| colegiado.situacion_colegial && !colegiado.migrado && !colegiado.sociedad_profesional}

  def validate
    errors.add("domiciliar_pagos", "Domiciliar pagos no puede estar vacío.") if self.situacion_colegial && !self.migrado && self.domiciliar_pagos.nil?
    col = Colegiado.find_by_id(self.id)
    errors.add("situacion_colegial", "El registro sólo puede pasar a estado '#{DATOS_OBJETO_PRINCIPAL[:ESTADO_ACTIVO]}'") if (!col || !col.situacion_colegial) && self.situacion_colegial && self.situacion_colegial != DATOS_OBJETO_PRINCIPAL[:ESTADO_ACTIVO].to_s
    if self.situacion_colegial == DATOS_OBJETO_PRINCIPAL[:ESTADO_ACTIVO].to_s && !self.migrado && !(errores_alta = revisar_condiciones_alta).blank?
      errors.add("situacion_colegial", errores_alta) 
    end
    if self.situacion_colegial == DATOS_OBJETO_PRINCIPAL[:ESTADO_BAJA].to_s && !(errores_baja = revisar_condiciones_baja).blank?
      errors.add("situacion_colegial", errores_baja)
    end
    if self.situacion_colegial == DATOS_OBJETO_PRINCIPAL[:ESTADO_EXENTO].to_s && !(errores_cambio = revisar_condiciones_no_ejerciente).blank?
      errors.add("situacion_colegial", errores_cambio)
    end
    errors.add("cuota_ingreso_forma_pago", "Debe indicar la forma de pago de la cuota de ingreso.") if self.motivo_ingreso == TipoProcedencia.find_by_nombre("nuevo_ingreso") && !self.migrado && self.cuota_ingreso_forma_pago.nil?
    errors.add("num_cuenta", "El número de cuenta es incorrecto") if !num_cuenta.blank? && !CustomValidator::SpanishAccount.validate(num_cuenta.gsub(' ', '').gsub('-', ''))
    errors.add("doc_identidad", "El documento de identidad es incorrecto") if tipo_doc_identidad && tipo_doc_identidad == 'nif' && doc_identidad && !CustomValidator::SpanishVAT.validate(doc_identidad.gsub('-', ''))
    errors.add("colegiado_profesiones", "Debe seleccionar al menos una titulación") if colegiado_profesiones.empty? && OBJETO_PRINCIPAL == 'colegiado'
  end

  after_create :crear_expediente
  after_save :crear_expediente
  def crear_expediente
    if !self.expediente
      Colegiado.transaction do
        e = Expediente.create(:titulo => "Expediente #{'provisional ' if !self.num_colegiado || self.num_colegiado == 0}del #{OBJETO_PRINCIPAL} #{self.num_colegiado if (self.num_colegiado && self.num_colegiado != 0)}", :tipo => OBJETO_PRINCIPAL)
        self.expediente = e
        self.save false #Estamos en after_save luego podemos guardar sin validación
      end
    end
  end

  EJERCICIOS_PROFESIONALES = DATOS_OBJETO_PRINCIPAL[:EJERCICIOS_PROFESIONALES]

  SITUACIONES_PROFESIONALES = DATOS_OBJETO_PRINCIPAL[:SITUACIONES_PROFESIONALES]

  SITUACIONES_COLEGIALES = DATOS_OBJETO_PRINCIPAL[:ESTADOS]

  GRADOS_CARRERA = DATOS_OBJETO_PRINCIPAL[:GRADOS_CARRERA]

  def etiquetas_obligatorias(todas = false)
    return DATOS_OBJETO_PRINCIPAL[:ETIQUETAS_OBLIGATORIAS].map {|et| et[:etiqs]}.flatten.uniq if todas
    return [] unless situacion_colegial

    e = DATOS_OBJETO_PRINCIPAL[:ETIQUETAS_OBLIGATORIAS].detect {|et| et[:cond].call(self)}
    e ? e[:etiqs] : []
  end

  def etiquetas_optativas(todas = false)
    return DATOS_OBJETO_PRINCIPAL[:ETIQUETAS_OPTATIVAS].map {|et| et[:etiqs]}.flatten.uniq if todas
    return [] unless situacion_colegial

    e = DATOS_OBJETO_PRINCIPAL[:ETIQUETAS_OPTATIVAS].detect {|et| et[:cond].call(self)}
    e ? e[:etiqs] : []
  end

  def to_label
    "Col. ##{self.num_colegiado} - #{self.nombre_completo} - #{self.doc_identidad}"
  end

  def nombre_completo
    "#{self.nombre} #{self.apellido1} #{self.apellido2}"
  end
  
  def apellidos
    "#{self.apellido1} #{self.apellido2}" if self.apellido1 || self.apellido2
  end

  def nif
    self.doc_identidad
  end

  def foto
    expediente.expedientes_gestiones.detect {|eg| eg.etiquetas.map {|et| et.etiqueta.to_sym}.include?(:foto_documento_identidad)}.gestion_documental.documento rescue nil
  end

  # situaciones colegiales
  SITUACIONES_COLEGIALES.each do |sc|
    class_eval <<-EOC
      def #{sc}?
        situacion_colegial == '#{sc}'
      end
    EOC
  end

  def saldo(conds = [])
    conditions = ["fecha_anulacion is null and fecha_devolucion is null"]
    if not conds.blank?
      conditions[0] << " AND (#{conds[0]})"  
      conditions += conds[1..-1]
    end
    tot = movimientos.sum('importe', :conditions => conditions)
    tot.abs < 0.00001 ? 0 : tot
  end

  def saldo_cuotas_colegiacion
    saldo ["concepto_de = ?", DATOS_MOVIMIENTOS[:CONCEPTO_CUOTA_PERIODICA].to_s]
  end

  def saldo_cursos
    saldo ["concepto_de = ?", 'curso']
  end

  def saldo_otros
    saldo ["concepto_de = ?", 'otro']
  end

  def deuda
    saldo > 0 ? saldo : 0
  end

  def deudor?
    saldo > 0
  end

  def procesar_alta
    #Buscamos el último número de colegiado
    msg = ""
    if self.valid? && self.situacion_colegial == DATOS_OBJETO_PRINCIPAL[:ESTADO_ACTIVO].to_s && (self.num_colegiado.nil? || self.num_colegiado == 0)
      Colegiado.transaction do
        sig_num_colegiado = Colegiado.find_by_sql("select nextval('num_colegiado_seq') as sig_num_colegiado;").first['sig_num_colegiado']
        self.num_colegiado = sig_num_colegiado
        self.save false
        msg += "El número de #{OBJETO_PRINCIPAL} es el '#{self.num_colegiado}'."
        exp = self.expediente || Expediente.new
        exp.titulo = "Expediente del #{OBJETO_PRINCIPAL} #{self.num_colegiado}"
        exp.save
      end
    end
    plazos = (Colegio.actual.cuota_colegiacion_num_plazos || 0)
    cuota = (Colegio.actual.cuota_colegiacion || 0)
    return {:result => true, :msg => msg} if self.motivo_ingreso && self.motivo_ingreso.nombre != 'nuevo_ingreso'
    if cuota == 0
      msg += "No está definida la cuota de ingreso en los parámetros de la aplicación, deberá generar los movimientos de devengo (y pago en caso de pago al contado) a mano desde los movimientos del #{OBJETO_PRINCIPAL}. Recuerde especificar la cantidad de deuda y el plazo y activar el 'saldar deuda' en los datos económicos en caso de cuota de ingreso con pago aplazado."
    elsif Movimiento::FORMAS_PAGO_CAJA.include?(self.cuota_ingreso_forma_pago.to_sym)
      Movimiento.transaction do
        fecha = Time.now
        m_d = Movimiento.create(:concepto => "(Devengo) Cuota de ingreso",
                                :importe => cuota,
                                :concepto_de => DATOS_MOVIMIENTOS[:CONCEPTO_CUOTA_PERIODICA].to_s,
                                :fecha => (Time.utc(fecha.year, fecha.month, fecha.day, fecha.hour, fecha.min) if fecha),
                                :titular => self)

        #Pago de la matrícula, si es 'efectivo'. Añadimos 1min. para ordenarlas
        fecha += 60
        m_p = Movimiento.create(:concepto => "(Cobro) Cuota de ingreso",
                                :importe => (-1*cuota),
                                :concepto_de => DATOS_MOVIMIENTOS[:CONCEPTO_CUOTA_PERIODICA].to_s,
                                :forma_pago => self.cuota_ingreso_forma_pago,
                                :caja => (Thread.current[:current_user].caja),
                                :fecha => (Time.utc(fecha.year, fecha.month, fecha.day, fecha.hour, fecha.min) if fecha),
                                :titular => self)
        if !m_d.valid? || !m_p.valid?
          msg += "Ha habido algún problema con la generación de los movimientos de devengo y cobro de la cuota de ingreso al contado, por favor revíselos. Si falta alguno lo puede dar de alta a mano."
        else
          msg += "Se ha generado el movimiento de devengo, así como el cobro de la cuota de ingreso, por favor revíselos."
        end
      end
    elsif plazos == 0
        msg += "No está definido el número de plazos para el fraccionamiento de la cuota en los parámetros de la aplicación, se creará el movimiento de devengo pero deberá activar en el #{OBJETO_PRINCIPAL} el 'saldar deuda' y definir el valor de importe a saldar en cada remesa sucesiva."
    else
      Movimiento.transaction do
        fecha = Time.now
        m_d = Movimiento.create(:concepto => "(Devengo) Cuota de ingreso",
                                :importe => cuota,
                                :concepto_de => DATOS_MOVIMIENTOS[:CONCEPTO_CUOTA_PERIODICA].to_s,
                                :fecha => (Time.utc(fecha.year, fecha.month, fecha.day, fecha.hour, fecha.min) if fecha),
                                :titular => self)
        if !m_d.valid?
          msg += "Ha habido algún problema con la generación del devengo de cuota de ingreso aplazada, por favor revíselo."
        else
          msg += "Se ha generado el movimiento de devengo de la cuota de ingreso, por favor revíselo."
        end
        if self.domiciliar_pagos
          plazo = cuota.to_i / plazos
          resto = cuota.to_i % plazos
          cuota_a_saldar = plazo
          cuota_a_saldar += 1 if resto > 0
          self.saldar_deuda = true
          self.importe_deuda = cuota_a_saldar
          self.deuda_a_saldar = cuota
          self.save
          if !self.saldar_deuda || self.importe_deuda != cuota_a_saldar
            msg += "No se pudo activar el 'saldar deuda' para el cobro aplazado por remesa de la cuota de ingreso, revíselo y hágalo a mano en la ficha del #{OBJETO_PRINCIPAL}, indicando el importe periódico."
          else
            msg += "Se activó el 'saldar deuda' para la cuota de ingreso por el importe aplazado"
          end
        end
      end
    end
    return {:result => true, :msg => msg}
  end

  def procesar_no_ejerciente
    msg = "El #{OBJETO_PRINCIPAL} pasa a estar exento de pago, recuerde revisar el estado actual de movimientos."
    return {:result => true, :msg => msg}
  end

  def procesar_baja
    msg = "Recuerde revisar el estado actual de movimientos del #{OBJETO_PRINCIPAL}."
    return {:result => true, :msg => msg}
  end

  def self.conds_exento_pago
    #Aquí sólo los exentos de pago, los de baja no pagan pero no están exentos.
    ['(((fecha_ini_exencion_pago is not null or fecha_fin_exencion_pago is not null) and now()::date >= COALESCE(fecha_ini_exencion_pago, ?) and now()::date <= COALESCE(fecha_fin_exencion_pago, ?)) or situacion_colegial = ?)', '1970-01-01'.to_date, '2999-01-01'.to_date, DATOS_OBJETO_PRINCIPAL[:ESTADO_EXENTO].to_s]
  end

  def exento_de_pago?
    ((fecha_ini_exencion_pago || fecha_fin_exencion_pago) && Date.today >= (fecha_ini_exencion_pago || '1970-01-01'.to_date) && Date.today <= (fecha_fin_exencion_pago || '2999-01-01'.to_date)) || situacion_colegial == DATOS_OBJETO_PRINCIPAL[:ESTADO_EXENTO].to_s
  end

  def documentos
    (self.etiquetas_obligatorias(true)+self.etiquetas_optativas(true)).select {|e| self.expediente.etiqs_docs_expediente.include?(e)}
  end

  def documentos_que_faltan
    self.etiquetas_obligatorias.select {|e| !self.expediente.etiqs_docs_expediente.include?(e)}
  end

  # messages

  def warning_messages
    messages = []
    return messages if self.new_record?

    messages << "Este #{OBJETO_PRINCIPAL} está dado de baja." if self.send("#{DATOS_OBJETO_PRINCIPAL[:ESTADO_BAJA]}?")
    messages << "Este #{OBJETO_PRINCIPAL} está dado de baja pero no está declarado el motivo de la misma." if self.send("#{DATOS_OBJETO_PRINCIPAL[:ESTADO_BAJA]}?") && motivo_baja.nil?
    causa_exencion = self.motivo_baja && self.motivo_baja.descripcion
    messages << "Este #{OBJETO_PRINCIPAL} está exento de pagos (#{causa_exencion})." if self.send("#{DATOS_OBJETO_PRINCIPAL[:ESTADO_EXENTO]}?")
    messages << "Este #{OBJETO_PRINCIPAL} no tiene asignada domiciliación de pagos." if !self.send("#{DATOS_OBJETO_PRINCIPAL[:ESTADO_EXENTO]}?") && !domiciliar_pagos?
    messages << "No se ha indicado un número de cuenta." if num_cuenta.blank?
    messages << "Este #{OBJETO_PRINCIPAL} tiene una deuda de #{ExportUtils.value2text(deuda)} €." if deudor?
    messages << "Este #{OBJETO_PRINCIPAL} tiene un saldo positivo de #{ExportUtils.value2text(saldo.abs)} €." if saldo < 0
    messages << "El expediente de este #{OBJETO_PRINCIPAL} no se creó en el momento de darlo de alta, al guardar la ficha se creará automáticamente si no, contacte con el administrador." if !self.expediente
    messages << "Este #{OBJETO_PRINCIPAL} tiene errores generados en la migración desde la aplicación anterior: #{self.err_migracion}" if self.err_migracion
    docs = []
    docs << "Documentación del expediente incompleta, falta: #{self.documentos_que_faltan.join(', ')}" if self.expediente && !self.documentos_que_faltan.empty?
    docs << "La documentación obligatoria presente en el expediente hasta el momento es: #{self.documentos.join(', ')}"
    docs = docs.join('<br />')
    messages << docs
    return messages
  end

  def revisar_condiciones_alta
    errores = []
    errores << "Debe introducir la fecha efectiva de ingreso así como seleccionar su motivo" if self.fecha_ingreso.nil? || self.motivo_ingreso.nil?
    errores << "Debe seleccionar el destino anterior en caso de ingreso por traslado de expediente" if self.motivo_ingreso && self.motivo_ingreso.nombre == 'traslado_expediente' && self.procedencia.nil?
    errores << "Debe crear primero el expediente. Para ello, deje en blanco el estado, guarde y vuelva a seleccionarlo." if !self.expediente
    errores << "El expediente del #{OBJETO_PRINCIPAL} tiene algún error" if self.expediente && !self.expediente.valid?
    errores << "Debe abrir el expediente del #{OBJETO_PRINCIPAL} introduciendo la fecha" if self.expediente && self.expediente.fecha_apertura.nil? && self.situacion_colegial != DATOS_OBJETO_PRINCIPAL[:ESTADO_BAJA].to_s
    #No se puede llamar al método completo? del expediente ni al propio de documentos_que_faltan porque consultan la instancia en bbdd del colegiado y no la que estamos validando (en memoria).
    docs_faltan = self.etiquetas_obligatorias.select {|e| !self.expediente.etiqs_docs_expediente.include?(e.to_sym) }.map {|d| d.to_s.humanize} if self.expediente
    errores << "Documentación del expediente incompleta, falta: #{docs_faltan.join(', ')}" if self.expediente && !docs_faltan.empty?
    return "Ha habido errores al procesar el alta: #{errores.join("<BR />")}." unless errores.empty?
  end

  def revisar_condiciones_baja
    errores = []
    errores << "Debe introducir la fecha efectiva de la baja así como seleccionar su motivo" if self.fecha_baja.nil? || self.motivo_baja.nil?
    errores << "Debe seleccionar el destino en caso de baja por traslado de expediente" if self.motivo_baja && self.motivo_baja.nombre == 'traslado_expediente' && self.destino.nil?
    errores << "Debe cerrar el expediente del #{OBJETO_PRINCIPAL} introduciendo la fecha" if self.expediente && self.expediente.fecha_cierre.nil?
    if self.motivo_baja && TipoDestino::BAJAS_SOLICITADAS.include?(self.motivo_baja.nombre.to_sym)
      errores << "Debe añadir el documento de solicitud de baja" if self.expediente && !self.expediente.tiene_doc?('solicitud_baja')
    elsif self.motivo_baja && TipoDestino::BAJAS_RESOLUCION_COLEGIAL.include?(self.motivo_baja.nombre.to_sym)
      errores << "Debe añadir el documento de resolución de baja" if self.expediente && !self.expediente.tiene_doc?('resolucion_baja')
    end
    return "Ha habido errores al procesar la baja: #{errores.join('; ')}." unless errores.empty?
  end

  def revisar_condiciones_no_ejerciente
    errores = []
    errores << "Debe añadir el documento de solicitud del #{OBJETO_PRINCIPAL} o en su caso de resolución de la junta para el cese de ejercicio" if self.expediente && !(self.expediente.tiene_doc?('solicitud_no_ejerciente') || self.expediente.tiene_doc?('resolucion_no_ejerciente'))
    return "Ha habido errores al procesar el cese de ejercicio del #{OBJETO_PRINCIPAL}: #{errores.join('; ')}." unless errores.empty?
  end
end
