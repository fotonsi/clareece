class EntidadAcreditadora < ActiveRecord::Base
  has_many :acreditaciones, :class_name => 'CursoAcreditacion'

  def to_label
    self.nombre
  end
end
