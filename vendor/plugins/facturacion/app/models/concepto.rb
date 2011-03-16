# Conceptos de facturación.

class Concepto < ActiveRecord::Base
  belongs_to :objeto, :polymorphic => true
  belongs_to :origen, :polymorphic => true
  has_many :factura_detalles
  has_many :precios

  def to_label
    "#{self.descripcion} (#{self.codigo})"
  end
end
