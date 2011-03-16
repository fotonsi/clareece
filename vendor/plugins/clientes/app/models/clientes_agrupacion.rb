class ClientesAgrupacion < ActiveRecord::Base
  belongs_to :clientes_cliente_individual
  belongs_to :clientes_cliente_grupo
end
