class Formacion < ActiveRecord::Base
  belongs_to :alumno, :polymorphic => true
  belongs_to :curso
  has_one :titulo
  has_many :movimientos, :as => :origen, :dependent => :nullify, :order => 'id'

  ESTADOS = [:matriculado, :espera, :baja, :cancelado]
  FORMAS_PAGO = Movimiento::FORMAS_PAGO 
  FORMAS_PAGO_CAJA = Movimiento::FORMAS_PAGO_CAJA

  validates_uniqueness_of :alumno_id, :scope => [:alumno_type, :curso_id, :estado], :message => 'El colegiado ya está matriculado en este curso.'

  def validate_on_create
    matricular_validations.each{|message|
      errors.add_to_base(message)
    }
  end
  
  def matricular_validations
    messages = []
    messages << "No hay plazas libres para este curso" if curso && !curso.plazas_libres? && !self.estado == 'espera'
    messages << "Se ha vencido la fecha de matrícula" if curso && !curso.en_plazo_matricula?
    messages << "El curso ya se ha iniciado o se ha cancelado" if curso && !curso.sin_iniciar?
    messages << "Debe seleccionar un alumno" if not alumno
    movs_errors = self.movimientos.map {|m| m.errors.full_messages unless m.valid?}.compact
    messages << %|El movimiento de matrícula tiene los siguientes errores:\n#{movs_errors.join("\n")}| unless movs_errors.empty?
    return messages
  end

  # estados
  ESTADOS.each do |estado|
    class_eval <<-EOC
      def #{estado}?
        self.estado == "#{estado}"
      end
    EOC
  end

  def to_label
    "#{curso.titulo} (#{alumno.nombre_completo})"
  end

  def asociar_movimiento
    unless ['matriculado', 'espera', 'baja'].include?(estado)
      self.errors.add_to_base "No se puede asociar movimiento a este alumno, está en estado #{self.estado}."
      return self
    end
    Formacion.transaction do
      # cargo
      fecha = Time.now
      #Devengo de la matrícula
      self.movimientos << Movimiento.new(:concepto => "(Devengo matrícula) #{curso.titulo}",
                                         :importe => curso.precio_matricula,
                                         :concepto_de => :curso.to_s,
                                         :fecha => (Time.utc(fecha.year, fecha.month, fecha.day, fecha.hour, fecha.min) if fecha),
                                         :titular => alumno)
      #Pago de la matrícula, si es 'efectivo'. Añadimos 1min. para ordenarlas
      fecha += 60
      if FORMAS_PAGO_CAJA.include?(forma_pago.to_sym)
        self.movimientos << Movimiento.new(:concepto => "(Cobro matrícula) #{curso.titulo}",
                                           :importe => (-1*curso.precio_matricula),
                                           :concepto_de => :curso.to_s,
                                           :forma_pago => forma_pago,
                                           :caja => (Thread.current[:current_user].caja),
                                           :fecha => (Time.utc(fecha.year, fecha.month, fecha.day, fecha.hour, fecha.min) if fecha),
                                           :titular => alumno)
      end
    end
  end

  def baja!
    # Anulamos devengo
    m = self.anular_devengo_matricula
    if m.nil? || m == -1 || m.valid?
      self.estado = :baja.to_s
      self.save
      if m == -1
        raise "Se dio de baja la matrícula pero quedaron movimientos asociados (ids. #{self.movimiento_ids}), es posible que se haya efecutado un pago."
      end
    else
      raise "No se pudo anular el movimiento de matrícula (mov. nº #{mov.id}), por favor realice la anulación a mano: #{m.errors.full_messages}"
    end
  end

  def anular_devengo_matricula
    # El devengo es el de importe > 0
    devengo = movimientos.find(:first, :conditions => ['importe > 0'])
    if devengo
	devengo.fecha_anulacion = Time.now
    	devengo.save
    end
    return -1 if devengo.nil? && !self.movimientos.empty?
    
    devengo
  end

  def devolucion!
    self.anular_devengo_matricula
    m = self.devolver_pago_matricula
    if m && m.valid?
      self.movimientos << m
      self.save
    elsif m && !m.valid?
      raise "No se pudo crear el movimiento de devolución #{m.errors.full_messages}"
    else
      raise "No se ha realizado devolución porque no existe ningún pago"
    end
  end

  def devolver_pago_matricula
    #El pago es el de importe < 0
    pago = movimientos.find(:first, :conditions => ['importe < 0'])
    fecha = Time.now
    if pago
      m = Movimiento.new(:concepto => "(Devolución matrícula) #{curso.titulo}",
                                         :importe => (curso.precio_matricula),
                                         :concepto_de => :curso.to_s,
                                         :forma_pago => forma_pago,
                                         :caja => (Thread.current[:current_user].caja),
                                         :fecha => (Time.utc(fecha.year, fecha.month, fecha.day, fecha.hour, fecha.min) if fecha),
                                         :titular => alumno)
    end
    m
  end

  campos_curso = [:titulo, :codigo, :fecha_ini, :fecha_fin, :aula, :fecha, :horario, :fecha_limite_devolucion, :hora_limite_devolucion, :texto_curso, :firma_presidente, :firma_secretario]
  campos_curso.each do |campo|
    class_eval <<-EOC
      def #{campo}
        self.curso.send("#{campo}")
      end
    EOC
  end

  campos_alumno = [:nombre_completo, :nombre, :apellidos]
  campos_alumno.each do |campo|
    class_eval <<-EOC
      def #{campo}
        self.alumno.send("#{campo}")
      end
    EOC
  end

  def hoy
    Date.today
  end

  def texto_hoy
    f = Date.today
    "#{f.mday} de #{f.strftime('%B')} de #{f.year}."
  end

  #def apto?
  #  (self.nota ||0) >= NOTA_APROBADO && self.asistencia_de(f.alumno) > PORC_MIN_ASISTENCIA
  #end

  def genera_contrato
    require 'pdf_utils'
    plantilla = DIR_PLANTILLAS_PDF+"/plantilla_contrato_curso.pdf"
    return PDF::rellenar(plantilla, self)
  end

  def genera_diploma(fecha = self.fecha_registro_titulo || Date.today)
    #Al generar diploma registramos únicamente el título correspondiente
    #  Siempre se imprimirán desde combinación de correspondencia, aunque sea 1 sólo.
    #No asociamos con gestión documental porque ahora se generará salida de un resumen de todos los de un curso.
    #  En caso de generar uno a posteriori se escanearía y se generaría la salida de el mismo.
    titulo = Titulo.new
    titulo.fecha = Time.utc(fecha.year, fecha.month, fecha.day)
    titulo.formacion = self
    titulo.save
    titulo if titulo.valid?
  end

  # virtual methods

  def colegiado_id
    alumno.is_a?(Colegiado) ? alumno.id : nil
  end

  def colegiado_id=(id)
    self.alumno = Colegiado.find(id)
  end

  # messages

  def warning_messages
    messages = []
    return messages if self.new_record?

    messages << "Este colegiado se ha dado de baja en el curso." if estado == :baja.to_s 
    messages << "Este curso se ha cancelado." if estado == :cancelado.to_s
    return messages
  end

  def nombre_curso
    self.curso.nombre if self.curso
  end

end
