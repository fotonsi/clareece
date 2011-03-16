class ClientesClienteGruposController < ApplicationController
  active_scaffold :clientes_cliente_grupo do |config|
    config.list.columns = [:nombre, :clientes_agrupaciones]
    config.create.columns = [:nombre]
    config.update.columns = [:nombre]
    config.list.label = "Clientes: Grupos"
  end
end
