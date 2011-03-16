class ClientesClienteGrupo < ClientesCliente
  has_many :clientes_agrupaciones, :dependent => :destroy

  def to_label
    "#{nombre}"
  end
end
