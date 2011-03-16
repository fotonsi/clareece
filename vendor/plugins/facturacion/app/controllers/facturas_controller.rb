class FacturasController < ApplicationController
  active_scaffold :factura do |config|
    config.list.columns = [:numero, :cliente, :fecha, :detalles]
  end
end
