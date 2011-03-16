class Colegio < ActiveRecord::Base
  belongs_to :localidad

  validates_presence_of [:recargo_bancario, :dia_trans_deuda], :message => "Es un campo obligatorio"

  def validate
    num_cuenta = "#{entidad}#{oficina}#{dc}#{cuenta}"
    errors.add("num_cuenta", "El número de cuenta es incorrecto") if !num_cuenta.blank? && !CustomValidator::SpanishAccount.validate(num_cuenta.gsub(' ', '').gsub('-', ''))
  end

  DEFAULTS = {
    'recargo_bancario' => -0.5,
    'dia_trans_deuda' => 1
  }

  after_save :desactivar_colegios

  def desactivar_colegios
    if self.actual?
      Colegio.find(:all).each{|colegio|
        next if colegio == self
        colegio.actual = false
        colegio.save
      }
    end
  end


  def self.actual
    #FIXME Para múltiples select hay que sacarlo a una tabla local o un fichero local de configuración
    find(:first, :conditions => {:actual => true}) || find(:first)
  end

  def self.recargo_bancario
    (actual and actual.recargo_bancario) or DEFAULTS['recargo_bancario']
  end

end
