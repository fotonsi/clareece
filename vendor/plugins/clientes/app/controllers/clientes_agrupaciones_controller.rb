class ClientesAgrupacionesController < ApplicationController
  active_scaffold :clientes_agrupaciones do |config|
    config.list.columns = [:nombre]
    config.columns[:nombre].includes = [:clientes_cliente_individual]
  end
end
