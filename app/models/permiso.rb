class Permiso < ActiveRecord::Base
  has_and_belongs_to_many :roles

  def to_label
    self.descripcion || self.nombre
  end
end
