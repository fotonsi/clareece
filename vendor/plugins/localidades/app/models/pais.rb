class Pais < ActiveRecord::Base
  has_many :provincias

  def to_label
    self.nombre
  end
end
