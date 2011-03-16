class Factura < ActiveRecord::Base
  has_many :detalles, :class_name => 'FacturaDetalle'
  belongs_to :cliente

  def to_label
    "Factura"
  end
end
