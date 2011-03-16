class FacturaDetalle < ActiveRecord::Base
  belongs_to :factura
  belongs_to :concepto

  def to_label
    "Detalle Factura"
  end

  def before_save()
    self.total = self.precio * self.cantidad
  end
end
