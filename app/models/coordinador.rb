class Coordinador < ActiveRecord::Base
  has_many :curso_coordinadores, :dependent => :destroy

  def validate
    errors.add("num_cuenta", "El número de cuenta es incorrecto") if !num_cuenta.blank? && !CustomValidator::SpanishAccount.validate(num_cuenta.gsub(' ', '').gsub('-', ''))
  end

  def nombre_completo
    "#{self.nombre} #{self.apellido1} #{self.apellido2}"
  end

  def to_label
    self.nombre_completo
  end
end
