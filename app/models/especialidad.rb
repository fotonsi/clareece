class Especialidad < ActiveRecord::Base
  has_many :colegiado_especialidades

  def to_label
    self.nombre
  end
end
