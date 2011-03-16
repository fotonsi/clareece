class ClientesClienteIndividualJuridico < ClientesClienteIndividual
  has_many :clientes_contactos, :as => :padre, :dependent => :nullify
end
