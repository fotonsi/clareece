class Precio < ActiveRecord::Base
  belongs_to :origen, :polymorphic => true
  belongs_to :cliente
  belongs_to :concepto
  belongs_to :impuesto

  def to_label
    "Precio"
  end

end
