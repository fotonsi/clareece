class Curso < ActiveRecord::Base
  has_many :horarios, :class_name => 'CursoHorario', :dependent => :destroy
  has_many :acreditaciones, :class_name => 'CursoAcreditacion', :dependent => :destroy
  has_many :formaciones, :dependent => :destroy
  has_many :curso_profesores, :dependent => :destroy
  has_many :curso_coordinadores, :dependent => :destroy
  has_many :ausencias
  has_many :movimientos, :as => :origen, :dependent => :nullify, :order => 'id'
  belongs_to :aula

  # validations

  validates_presence_of [
    :nombre, :fecha_ini, :fecha_fin, :precio_matricula
  ], :message => "debe tener un valor"

  validate do |curso|
    Curso.column_names.each{|column|
      valid_method = "#{column}_validation"
      curso.send(valid_method) if curso.respond_to?(valid_method)
    }
  end

  # methods to validate

  def num_plazas_max_validation
    num_matriculados = matriculas.size
    if num_plazas_max < num_matriculados
      errors.add(:num_plazas_max, "debe ser mayor o igual a #{num_matriculados} ya que actualmente existe ese número de alumnos matriculados")
    end
  end

  def num_plazas_min_validation
    errors.add(:num_plazas_min, "debe ser inferior al aforo máximo.") if num_plazas_max && num_plazas_max != 0 && num_plazas_min > num_plazas_max
  end

  def num_plazas_max_validation
    errors.add(:num_plazas_max, "debe ser inferior a la capacidad del aula seleccionada (#{aula.capacidad})") if aula && aula.capacidad < num_plazas_max
  end

  def num_plazas_presenciales_validation
    errors.add(:num_plazas_presenciales, "debe ser menor que el aforo máximo") if num_plazas_presenciales && num_plazas_max && num_plazas_presenciales > num_plazas_max
  end

  def fecha_ini_validation
    errors.add(:fecha_ini, "La fecha de inicio debe ser anterior a la de finalización") if (fecha_ini > fecha_fin rescue nil)
  end

  def fecha_fin_validation
    errors.add(:fecha_fin, "La fecha de inicio debe ser anterior a la de finalización") if (fecha_ini > fecha_fin rescue nil)
  end

  def fecha_limite_matricula_validation
    errors.add(:fecha_limite_matricula, "La fecha límite de matrícula debe ser posterior a la de inicio") if (fecha_inicio_matricula >= fecha_limite_matricula rescue nil)
  end

  def fecha_limite_devolucion_validation
    errors.add(:fecha_limite_devolucion, "Si el precio de matrícula es mayor que 0 debe especificar la fecha límite de devolución") if precio_matricula > 0 && fecha_limite_devolucion.blank?
  end

  after_save :actualiza_estado

  # estados

  ESTADOS_ACTIVOS = [:sin_iniciar, :activo, :finalizado]
  ESTADOS_FINALES = [:acta, :cancelado]
  ESTADOS = ESTADOS_ACTIVOS + ESTADOS_FINALES

  before_save :default_values

  private

  def default_values
    self.estado ||= :sin_iniciar.to_s
    self.num_plazas_max = self.aula.capacidad if (self.num_plazas_max.nil? || self.num_plazas_max == 0) && self.aula
  end

  public

  def to_label
    "#{self.codigo} - #{self.nombre} (#{self.estado.humanize if self.estado} - #{self.fecha_ini})"
  end

  def titulo
    self.nombre
  end

  def codigo
    self.id
  end

  # métodos de estados
  ESTADOS.each do |estado|
    class_eval <<-EOC
      def #{estado}?
        estado == '#{estado}'
      end
    EOC
  end

  def en_plazo_devolucion?
    fecha_limite_devolucion >= Time.now rescue true
  end

  def en_plazo_matricula?
    fecha_limite_matricula >= Time.now rescue true
  end

  def plazas_libres?
    matriculas.size < (num_plazas_presenciales || num_plazas_max)
  end

  def num_plazas_libres
    (num_plazas_presenciales || 0) - matriculas.size
  end

  def posible_matricular?
    en_plazo_matricula? and plazas_libres? and sin_iniciar?
  end

  def colegiados
    colegiados = []
    formaciones.each{|formacion| 
      colegiados << formacion.alumno if formacion.alumno.is_a?(Colegiado)
    }
    return colegiados
  end

  def matriculas
    self.formaciones.select {|f| f.estado == "matriculado"}
  end

  def bajas
    self.formaciones.select{|f| f.estado == "baja"}
  end

  def lista_espera
    self.formaciones.select {|f| f.estado == "espera"}
  end

  def acreditado?
    !acreditaciones.empty?
  end

  def self.cursos_sin_iniciar
    Curso.find(:all, :conditions => ['estado in (?)', [:sin_iniciar.to_s, nil]])
  end

  def self.cursos_activos
    Curso.find_all_by_estado(:activo.to_s)
  end

  def self.cursos_finalizados
    Curso.find_all_by_estado(:finalizado.to_s)
  end

  def self.actualiza_estados
    (self.cursos_sin_iniciar+self.cursos_activos).each {|c| c.actualiza_estado}
  end

  def actualiza_estado
    case self.estado
    when :sin_iniciar.to_s
      if Date.today > self.fecha_fin
        self.estado = :finalizado.to_s
        self.save
      elsif Date.today >= self.fecha_ini
        self.estado = :activo.to_s
        self.save
      end
    when :activo.to_s
      if Date.today > self.fecha_fin
        self.estado = :finalizado.to_s
        self.save
      elsif Date.today < self.fecha_ini
        self.estado = :sin_iniciar.to_s
        self.save
      end
    when :finalizado.to_s
      if Date.today <= self.fecha_fin
        self.estado = :activo.to_s
        self.save
      elsif Date.today < self.fecha_ini
        self.estado = :sin_iniciar.to_s
        self.save
      end
    end
  end

  def cancelar!
    Curso.transaction do
      matriculas.each{|matricula|
        matricula.cancelar!
      }
      self.estado = :cancelado.to_s
      self.save
    end
  end

  def acta!
    Curso.transaction do
      matriculas.each{|matricula|
        #TODO calcular nota, etc
        self.genera_diplomas
      }
      self.estado = :acta.to_s
      self.save
    end
  end

  def fecha
    "del #{self.fecha_ini.strftime('%d/%m/%Y') rescue '--/--/----'} al #{self.fecha_fin.strftime('%d/%m/%Y') rescue '--/--/----'}"
  end

  def horario
    hors = []
    self.horarios.each do |h|
      dias = h.fecha_ini != h.fecha_fin ? "del #{h.fecha_ini.strftime('%d/%m/%Y') rescue '--/--/----'} al #{h.fecha_fin.strftime('%d/%m/%Y') rescue '--/--/----'}" : "el día #{h.fecha_ini.strftime('%d/%m/%Y') rescue '--/--/----'}"
      hors << "#{dias} de #{h.hora_ini} a #{h.hora_fin}"
    end
    return hors.join(", ")
  end

  def duracion_horas
    self.horarios.inject(0) {|suma,h| suma+(h.fecha_fin-h.fecha_ini+1)*("1980-01-01 #{h.hora_fin}".to_time-"1980-01-01 #{h.hora_ini}".to_time)/60/60}
  end

  def duracion_texto
    fecha_ini = self.horarios.map {|h| h.fecha_ini}.compact.sort.first
    fecha_fin = self.horarios.map {|h| h.fecha_fin}.compact.sort.first
    if fecha_ini.month == fecha_fin.month
      "del #{fecha_ini.day} al #{fecha_fin.day} de #{fecha_ini.strftime('%B')} de #{fecha_ini.year}"
    else
      "del #{fecha_ini.day} de #{fecha_ini.strftime('%B')} al #{fecha_fin.day} de #{fecha_fin.strfime('%B')} de #{fecha_ini.year}"
    end
  end

  def texto_curso
    #TODO Poner el texto en función de si tiene certificación o no
    "Ha realizado con aprovechamiento el Taller #{self.titulo.upcase} organizado por este #{NOMBRE_COLEGIO}, #{self.duracion_texto}, con una duración de #{self.duracion_horas.to_i} horas."
  end

  def turnos
    t = []
    self.horarios.sort_by {|h| h.fecha_ini}.each do |h| 
      ((h.fecha_ini.to_date)..(h.fecha_fin.to_date)).each {|f| t << [f, [h.hora_ini, h.hora_fin]]}
    end
    return t.sort_by {|t| [t[0], t[1][0].to_i]}
  end

  def asistencia_de(alumno)
    num_turnos = turnos.size
    return 0 if num_turnos == 0
    ausencias_alumno = self.ausencias.find_all_by_alumno_id_and_alumno_type(alumno.id, alumno.class.to_s.downcase).size rescue 0
    return (num_turnos-ausencias_alumno)*100/num_turnos
  end

  def aptos
    formaciones.select {|f| f.estado == 'matriculado' && f.apto?}
  end

  def genera_diplomas
    nums = Titulo.last.id rescue 0
    generados = [nums + 1]
    self.aptos.each do |formacion|
      titulo = formacion.genera_diploma
      nums += 1 if titulo
    end
    generados << nums
    generados
  end

  def firma_presidente
    FIRMA_PRESIDENTE
  end

  def firma_secretario
    FIRMA_SECRETARIO
  end

  # messages

  def warning_messages
    messages = []
    return messages if self.new_record?

    case estado
    when 'sin_iniciar'
      messages << "Quedan <b>#{num_plazas_libres}</b> plazas libres." if en_plazo_matricula?
      messages << "Se ha cerrado el plazo de matrícula de este curso." unless en_plazo_matricula?
    when 'activo'
    when 'finalizado'
      messages << "Se ha finalizado el curso, cuando haya generado los diplomas debe realizar el acta para cerrarlo."
    when 'acta'
      messages << "Curso cerrado."
    when 'cancelado'
      messages << "Este curso está cancelado."
    end
    return messages
  end

end
