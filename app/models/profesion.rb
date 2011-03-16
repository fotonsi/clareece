class Profesion < ActiveRecord::Base
  has_many :colegiado_profesiones

  def to_label
    self.nombre
  end
end
