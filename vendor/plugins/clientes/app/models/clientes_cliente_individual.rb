class ClientesClienteIndividual < ClientesCliente
  has_many :clientes_agrupaciones, :dependent => :destroy
end
