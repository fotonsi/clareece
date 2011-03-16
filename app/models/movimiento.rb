class Movimiento < ActiveRecord::Base
  belongs_to :titular, :polymorphic => true 
  belongs_to :origen, :polymorphic => true 
  belongs_to :caja
  belongs_to :devolucion_de, :class_name => 'Movimiento'

  FORMAS_PAGO = [:efectivo, :tarjeta, :domiciliacion, :transaccion, :paypal, :transferencia]
  FORMAS_PAGO_CAJA = [:efectivo, :paypal, :tarjeta, :transferencia]

  module Concepto
    TIPOS = [:cuota_colegiacion, :curso, :otro]
    def self.label(concepto)
      I18n.t "view.movimiento.concepto.#{concepto}"
    end
  end

  validates_presence_of :titular_id, :concepto, :importe, :concepto_de, :fecha
  validates_presence_of :forma_pago, :if => Proc.new {|mov| mov.titular_type != 'Colegiado' || mov.importe < 0}
  validates_numericality_of :importe

  def validate
    self.errors.add(:caja, "El movimiento debe informar la caja") if self.caja_id.nil? && FORMAS_PAGO_CAJA.include?(self.forma_pago)
    #self.errors.add(:importe, "Debe ser distinto de 0") if self.importe == 0
  end

  before_validation_on_create :default_values

  def default_values
    self.caja = Thread.current[:current_user].caja if !self.caja && FORMAS_PAGO_CAJA.include?(self.forma_pago)
  end

  def to_label
    %|(mov #{id}) #{concepto}|
  end

  def from?(klass)
    return false unless origen
    origen.is_a? klass
  end

  def saldo_inicial
    Movimiento.find(:all, :conditions => ["titular_type = ? and titular_id = ? and fecha_anulacion is null and fecha_devolucion is null and (fecha < ? or (fecha = ? and id < ?)) and id != ?", titular.class.name, titular.id, fecha, fecha, id, id], :select => "sum(importe)").first.sum.to_f
  end

  def saldo_final
    saldo_inicial + (fecha_devolucion.nil? && fecha_anulacion.nil? ? importe : 0)
  end

  def anulado?
    not fecha_anulacion.nil?
  end

  def devuelto?
    not fecha_devolucion.nil?
  end

  # Authorized methods

  def authorized_for_libramiento?
    importe > 0 && !anulado?
  end

  def authorized_for_recibo_cuota?
    importe < 0 && !anulado?
  end

  def authorized_for_devolucion?
    importe < 0 && !anulado? && !devolucion_de && !Movimiento.find_by_devolucion_de_id(self.id)
  end

  def authorized_for_update?
    cuadre = CajaCuadre.find(:first, :order => 'fecha', :conditions => ['fecha > ?', fecha])
    !cuadre || !cuadre.cerrado?
  end

  # Campos virtuales

  def colegiado_id
    titular.is_a?(Colegiado) ? titular.id : nil
  end

  def colegiado_id=(value)
    return if value.blank?
    self.titular = Colegiado.find_by_id(value)
  end

  def to_texto
    id = self.id.to_s.rjust(8)
    fecha = self.fecha.strftime('%d/%m/%Y %H:%M') rescue nil
    titular = ((self.titular.kind_of?(Colegiado) ? self.titular.to_label : self.a_favor_de)[0..59].ljust(60)) rescue nil
    concepto_de = (self.concepto_de.humanize if self.concepto_de).ljust(20)
    concepto = self.concepto[0..49].ljust(40)
    forma_pago = ((I18n.t "view.movimiento.forma_pago."+self.forma_pago) if self.forma_pago).ljust(10)
    importe = (self.importe.abs if self.importe).to_s.rjust(8)
    %|\| #{id} \| #{fecha} \| #{titular} \| #{concepto_de} \| #{concepto} \| #{forma_pago} \| #{importe} \||
  end

  def to_csv
    fecha = self.fecha.strftime('%d/%m/%Y %H:%M') rescue nil
    titular = (self.titular.kind_of?(Colegiado) ? self.titular.to_label : self.a_favor_de) rescue nil
    concepto_de = self.concepto_de.humanize if self.concepto_de
    concepto = self.concepto
    forma_pago = (I18n.t "view.movimiento.forma_pago."+self.forma_pago) if self.forma_pago
    importe = self.importe.abs.to_s.gsub('.', ',') if self.importe
    [self.id, fecha, titular, concepto_de, concepto, forma_pago, importe].join(';')
  end

  def crear_devengo
     Movimiento.create(:concepto => self.concepto.gsub('(Cobro ', '(Devengo '),
     		       :importe => -1*self.importe,
		       :concepto_de => self.concepto_de,
  		       :fecha => (Time.utc(self.fecha.year, self.fecha.month, self.fecha.day, self.fecha.hour, self.fecha.min) if self.fecha),
		       :titular => self.titular)
  end

  def devolucion
    Movimiento.transaction do
      fecha = Time.now
      #Devengo de la devolución
      m_d = Movimiento.create(:concepto => "(Devengo devolución) #{self.concepto}",
                                         :importe => self.importe,
                                         :concepto_de => self.concepto_de,
                                         :forma_pago => self.forma_pago,
                                         :caja => (Thread.current[:current_user].caja if FORMAS_PAGO_CAJA.include?(self.forma_pago)),
                                         :fecha => (Time.utc(fecha.year, fecha.month, fecha.day, fecha.hour, fecha.min) if fecha),
                                         :titular => self.titular,
                                         :devolucion_de_id => self.id)
      m_p = Movimiento.create(:concepto => "(Devolución) #{self.concepto}",
                                         :importe => -1*self.importe,
                                         :concepto_de => self.concepto_de,
                                         :forma_pago => self.forma_pago,
                                         :caja => (Thread.current[:current_user].caja if FORMAS_PAGO_CAJA.include?(self.forma_pago)),
                                         :fecha => (Time.utc(fecha.year, fecha.month, fecha.day, fecha.hour, fecha.min) if fecha),
                                         :titular => self.titular,
                                         :devolucion_de_id => self.id)
      if !m_d.valid?
        raise "El movimiento de devengo tiene errores: #{m_d.errors.full_messages}"
      elsif !m_p.valid?
        raise "El movimiento de devolución tiene errores: #{m_p.errors.full_messages}"
      end
    end

  end
end
