class Recibo < ActiveRecord::Base
  belongs_to :remesa
  belongs_to :titular, :polymorphic => true
  has_many :movimientos, :as => :origen, :order => 'id', :dependent => :destroy

  validates_presence_of :titular_id, :concepto_de, :concepto, :importe_total, :remesa

  def validate
    if self.importe_total == 0
      self.errors.add :importe_total, "debe ser distinto de 0"
    end
  end

  ESTADOS = [:sin_generar, :generado, :anulado, :devuelto]

  def before_save
    #Por ahora las domiciliaciones siempre son abonos.
    self.importe = -1*(self.importe.abs)
    self.importe1 = -1*(self.importe1.abs)
    self.importe2 = -1*(self.importe2.abs)
    self.importe3 = -1*(self.importe3.abs)
    self.importe4 = -1*(self.importe4.abs)
    self.importe5 = -1*(self.importe5.abs)
    self.importe_total = -1*(self.importe_total.abs)
  end

  # Se crean con estado :sin_generar.
  def initialize(*args)
    super
    self.estado = :sin_generar.to_s
  end

  # Métodos para comprobación de estados 
  ESTADOS.each do |estado|
    class_eval <<-EOC
      def #{estado}?
        self.estado == "#{estado}"
      end
    EOC
  end

  def fecha
    remesa.fecha_cobro
  end

  def importe_final
    if movimientos.count == 0
      importe_total
    else
      movimientos.sum('importe', :conditions => ['fecha_anulacion is null and fecha_devolucion is null'])
    end
  end

  def generar!
    Recibo.transaction do
      generar_movimientos
      self.estado = 'generado'
      self.save
    end
  end

  def generar_movimientos
    Recibo.transaction do
      # Registro obligatorio
      fecha_mov = Time.utc(fecha.year, fecha.month, fecha.day) if fecha
      if importe != 0 
        Movimiento.create(:titular => titular, :origen => self, :concepto_de => concepto_de, :concepto => concepto, 
                          :importe => importe, :forma_pago => :domiciliacion.to_s, :fecha => fecha_mov)
      end

      # Registros opcionales (1 al 5)
      (1..5).each do |index|
        if send("importe#{index}") != 0
          Movimiento.create(:titular => titular, :origen => self, :concepto_de => send("concepto_de#{index}"), 
                            :concepto => send("concepto#{index}"), :importe => send("importe#{index}"), :forma_pago => :domiciliacion.to_s, :fecha => fecha_mov)
        end
      end
    end
  end

  def anular! 
    Recibo.transaction do
      anular_movimientos
      self.estado = 'anulado'
      self.save
    end
  end

  def anular_movimientos
    Recibo.transaction do
      movimientos.each do |movimiento| 
        # Anulación
        attributes = {}
        %w(titular origen concepto_de forma_pago).each{|i| attributes[i.to_sym] = movimiento.send(i)}
        attributes[:concepto] = "(-) #{movimiento.concepto}"
        attributes[:importe] = -1 * movimiento.importe
        attributes[:fecha] = Date.today
        Movimiento.create attributes
      end
    end
  end

  def devolver! 
    Recibo.transaction do
      anular_movimientos
      generar_recargo_bancario
      self.estado = 'devuelto'
      self.save
    end
  end

  def generar_recargo_bancario
    Recibo.transaction do
      Movimiento.create :titular => titular, :origen => self, :concepto_de => 'otro', :concepto => "RECARGO BANCARIO #{concepto}", 
        :forma_pago => 'efectivo', :importe => Colegio.recargo_bancario, :fecha => Date.today
    end
  end

  def registro_archivo_bancario
    registros = []
    c = Colegio.first
    t = self.titular
    registros << "5680"+(c.cif || '').ljust(12).gsub(' ', '0')+(t.num_colegiado || '').to_s.ljust(12)+(Iconv.new('ISO-8859-15','UTF-8//IGNORE//TRANSLIT').iconv(t.nombre_completo) || '').ljust(40)[0..39]+(t.num_cuenta || '').gsub(' ', '').gsub('-', '')+"%010d" % (self.importe_total.abs*100)+"0"*6+" "*10+((Iconv.new('ISO-8859-15','UTF-8//IGNORE//TRANSLIT').iconv(self.concepto) || '')+" "+importe.abs.to_s.gsub('.', ',')).ljust(40)[0..39]+" "*8
    (1..5).each do |num|
      conc = self.send("concepto#{num}")
      impo = self.send("importe#{num}")
      if conc || impo != 0
        registros << "568#{num}"+(c.cif || '').ljust(12).gsub(' ', '0')+(t.num_colegiado || '').to_s.ljust(12)+" "*40+((Iconv.new('ISO-8859-15','UTF-8//IGNORE//TRANSLIT').iconv(conc) || '')+" "+impo.abs.to_s).ljust(40)[0..39]+" "*40+" "*14
      end
    end
    if !t.titular_cuenta
      registros << "5686"+(c.cif || '').ljust(12).gsub(' ', '0')+(t.num_colegiado || '').to_s.ljust(12)+(Iconv.new('ISO-8859-15','UTF-8//IGNORE//TRANSLIT').iconv(t.nombre_titular_cuenta) || '').ljust(40)[0..39]+(Iconv.new('ISO-8859-15','UTF-8//IGNORE//TRANSLIT').iconv(t.domicilio_titular_cuenta || t.direccion) || '').ljust(40)[0..39]+(Iconv.new('ISO-8859-15','UTF-8//IGNORE//TRANSLIT').iconv(t.plaza_domicilio_titular_cuenta || t.localidad) || '').ljust(35)[0..34]+(t.cp_titular_cuenta || t.cod_postal || '').ljust(5)+" "*14
    end
    registros
  end

  # Campos virtuales

  def colegiado_id
    titular.is_a?(Colegiado) ? titular.id : nil
  end

  def colegiado_id=(value)
    return if value.blank?
    self.titular = Colegiado.find_by_id(value)
  end


  # Authorized methods

  def authorized_for_edit?
    sin_generar?
  end

  def authorized_for_generar?
    sin_generar? and remesa.entregado?
  end

  def authorized_for_anular?
    generado?
  end

  def authorized_for_devolver?
    generado?
  end

  def authorized_for_destroy?
    sin_generar?
  end

end
