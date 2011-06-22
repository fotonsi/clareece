class Remesa < ActiveRecord::Base
  has_many :recibos, :dependent => :destroy, :order => 'id' 
  belongs_to :fichero_bancario, :class_name => 'Documento'

  validates_presence_of :fecha_cobro
  validates_presence_of :concepto_de, :concepto, :importe_total, :if => Proc.new{|remesa| remesa.general?}

  def validate
    if self.general? and self.importe_total == 0
      self.errors.add :importe_total, "debe ser distinto de 0"
    end
  end

  TIPOS = [:general, :individual]
  ESTADOS = [:sin_generar, :generado, :entregado, :anulado]

  # Se crean con estado :sin_generar.
  def before_create
    self.estado = self.general? ? :sin_generar.to_s : :generado.to_s
  end

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


  def to_label
    "(#{id}) #{concepto}"
  end

  # Métodos para comprobación de tipos
  TIPOS.each do |tipo|
    class_eval <<-EOC
      def #{tipo}?
        self.tipo == "#{tipo}"
      end
    EOC
  end

  # Métodos para comprobación de estados 
  ESTADOS.each do |estado|
    class_eval <<-EOC
      def #{estado}?
        self.estado == "#{estado}"
      end
    EOC
  end

  def generacion_programada?
    sin_generar? and fecha_generacion?
  end

  def entrega_programada?
    generado? and fecha_entrega
  end

  def anulacion_programada?
    entregado? and fecha_anulacion
  end

  def importe_final
    #Total por movimientos (una vez entregada)
    #Remesa.calculate('sum', 'importe', :joins => "left join recibos on remesas.id = recibos.remesa_id left join movimientos on recibos.id = movimientos.origen_id and movimientos.origen_type = 'Recibo'", :conditions => ['remesas.id = ?', self.id])
    #Total por recibos (una vez generada)
    recibos.sum('importe_total')
  end

  def num_movimientos
    recibos.count
  end

  def generar!
    Remesa.transaction do
      generar_recibos
      self.estado = 'generado'
      self.save
    end
  end

  def self.a_generar_hoy
    find(:all, :conditions => ['fecha_generacion = ? and estado <> ?', Date.today, 'sin_generar'])
  end

  def self.generar_pendientes!
    a_generar_hoy.each {|t| t.generar!}
  end

  def self.generar_individual_saldar_deuda(fecha_cobro = Date.today, concepto_de = DATOS_MOVIMIENTOS[:CONCEPTO_CUOTA_PERIODICA].to_s, concepto = '(Cobro) Deuda aplazada', importe_ini = nil)
    Remesa.transaction do
      r = Remesa.new(:fecha_cobro => fecha_cobro, :tipo => :individual.to_s)
      Colegiado.find(:all, :conditions => ['saldar_deuda is true and importe_deuda > 0']).each do |col|
        importe = !importe_ini || importe_ini.to_f == 0 ? col.importe_deuda.abs : importe_ini.to_f.abs
        col.deuda_a_saldar ||= 0
        (importe = col.deuda_a_saldar.abs) if col.deuda_a_saldar < importe
        next if importe == 0
        rec = Recibo.new(:estado => :sin_generar.to_s, :concepto_de => concepto_de, :concepto => concepto, :importe => importe, :importe_total => importe, :titular => col, :remesa_id => r.id)
        rec.remesa = r
        r.recibos << rec
        col.deuda_a_saldar -= importe
        col.saldar_deuda = false if col.deuda_a_saldar == 0
        col.save false
      end
      r.save
      raise "Se encontraron los siguientes errores: #{r.errors.full_messages}" if !r.valid?
      r
    end
  end

  def generar_recibos
    Remesa.transaction do
      # Condiciones
      conds = Colegiado.conds_exento_pago
      conds[0] = "not (#{conds[0]} or situacion_colegial = ?)"
      conds << 'baja_colegial'
      conds[0] << " and domiciliar_pagos is true"
      
      # Colegiados
      colegiados = Colegiado.find(:all, :order => 'num_colegiado', :conditions => conds, :limit => RECIBOS_REMESA_A_GENERAR)
      
      # Recibos
      colegiados.each_with_index do |colegiado, index|
        attributes = {}
        %w(importe_total
           concepto_de   concepto    importe 
           concepto_de1  concepto1   importe1
           concepto_de2  concepto2   importe2
           concepto_de3  concepto3   importe3
           concepto_de4  concepto4   importe4
           concepto_de5  concepto5   importe5).map{|attr| attributes[attr.to_sym] = send(attr)}
        attributes.merge!(:titular => colegiado, :remesa => self)
        Recibo.create attributes
      end
    end
  end

  def entregar!
    Remesa.transaction do
      generar_movimientos
      self.estado = 'entregado'
      self.save
    end
  end

  def borrar_recibos!
    Remesa.transaction do
      recibos.find(:all, :conditions => {:estado => 'sin_generar'}).each {|recibo|recibo.destroy}
      self.estado = 'sin_generar'
      self.save
    end
  end

  def generar_movimientos
    Remesa.transaction do
      recibos.find(:all, :conditions => {:estado => 'sin_generar'}).each {|recibo|recibo.generar!}
    end
  end

  def anular! 
    Remesa.transaction do
      anular_movimientos
      self.estado = 'anulado'
      self.save
    end
  end

  def anular_movimientos
    Remesa.transaction do
      recibos.find(:all, :conditions => {:estado => 'generado'}).each {|recibo|recibo.anular!}
    end
  end

  def generar_fichero_bancario
    registros = []
    c = Colegio.first
    #Registro presentador
    registros << "5180"+(c.cif || '').ljust(12).gsub(' ', '0')+Date.today.strftime("%d%m%y")+" "*6+(Iconv.new('ISO-8859-15','UTF-8//IGNORE//TRANSLIT').iconv(c.nombre) || '').ljust(40)[0..39]+" "*20+(c.entidad || '')+(c.oficina || '')+" "*12+" "*40+" "*14
    #Registro ordenante
    registros << "5380"+(c.cif || '').ljust(12).gsub(' ', '0')+Date.today.strftime("%d%m%y")+self.fecha_cobro.strftime("%d%m%y")+(Iconv.new('ISO-8859-15','UTF-8//IGNORE//TRANSLIT').iconv(c.nombre) || '').ljust(40)[0..39]+(c.entidad || '')+(c.oficina || '')+(c.dc || '')+(c.cuenta || '')+" "*8+"01"+" "*10+" "*40+" "*14
    #Registros colegiados
    self.recibos.all(:joins => "join colegiados on recibos.titular_id = colegiados.id and recibos.titular_type = 'Colegiado'", :order => "rpad(colegiados.num_colegiado::varchar, 6, '0')").each do |recibo|
      registros += recibo.registro_archivo_bancario
    end
    total_importes = self.recibos.inject(0) {|suma, r| suma + r.importe_total}
    #Registro total ordenantes
    registros << "5880"+(c.cif || '').ljust(12).gsub(' ', '0')+" "*12+" "*40+" "*20+("%.2f" % (total_importes.abs)).gsub('.', ',')+" "*6+self.recibos.count.to_s.ljust(10)+(self.recibos.count+2).to_s.ljust(10)+" "*20+" "*18
    #Registro total presentador
    registros << "5980"+(c.cif || '').ljust(12).gsub(' ', '0')+" "*12+" "*40+"0001"+" "*16+("%.2f" % (total_importes.abs)).gsub('.', ',')+" "*6+(self.recibos.count).to_s.ljust(10)+(registros.size+1).to_s.ljust(10)+" "*20+" "*18

    #Guardamos el fichero y lo asociamos
    nombre_fichero = Documento.new.sanitize_filename("fichero_bancario_remesa_#{self.id}_#{self.fecha_cobro.strftime('%d%m%Y')}.afs")
    str = registros.join("\n")
    d = Documento.create
    nombre_dir = "#{Documento.attachment_options[:path_prefix]}/#{d.id}"
    Dir.mkdir(nombre_dir) if !File.exists? nombre_dir
    f = File.open("#{nombre_dir}/#{nombre_fichero}", "w")
    f.write str
    f.close
    d.content_type = 'text/plain'
    d.filename = nombre_fichero
    d.size = str.to_s.size
    d.save
    self.fichero_bancario = d
    self.save
  end

  # Messages

  def warning_messages
    messages = []
    return messages if new_record?
    messages << "Remesa GENERADA. Puede realizar modificaciones en los recibos antes de ENTREGAR la remesa." if general? && generado?
    messages << "Remesa ENTREGADA. Si lo desea puede anular la remesa." if entregado?
    messages << "Remesa ANULADA. No puede realizar modificaciones en esta remesa." if anulado?
    return messages
  end

  # AS authorized

  def authorized_for_edit?
    if general? 
      sin_generar?
    else
      not (entregado? or anulado?)
    end
  end

  def authorized_for_generar?
    general? and sin_generar?
  end

  def authorized_for_entregar?
    generado?
  end

  def authorized_for_anular?
    entregado?
  end

  def authorized_for_destroy?
    not (entregado? or anulado?)
  end

end
