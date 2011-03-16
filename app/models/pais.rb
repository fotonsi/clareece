class Pais < ActiveRecord::Base
  has_many :colegiados

  def to_label
    nombre
  end
end
