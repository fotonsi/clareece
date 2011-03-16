class Externo < ActiveRecord::Base
  def to_label
    "#{self.nombre_completo} (#{self.nif})"
  end

  def nombre_completo
    "#{self.nombre} #{self.apellido1} #{self.apellido2}"
  end
end
