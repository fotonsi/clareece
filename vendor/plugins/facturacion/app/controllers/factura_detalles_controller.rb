class FacturaDetallesController < ApplicationController
  active_scaffold :factura_detalle do |config|
    config.list.columns = [:numero, :descripcion, :cantidad, :precio, :impuesto, :total]
  end
end
