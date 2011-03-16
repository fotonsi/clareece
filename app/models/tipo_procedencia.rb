class TipoProcedencia < ActiveRecord::Base
  has_many :colegiados, :foreign_key => 'motivo_ingreso_id'

  def to_label
    self.descripcion
  end
end
