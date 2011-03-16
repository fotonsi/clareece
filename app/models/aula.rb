class Aula < ActiveRecord::Base
  has_many :cursos

  def to_label
    self.nombre
  end

  def nombre_aforo
    "#{self.nombre} (cap. #{self.capacidad})"
  end
end
