class ClienteJuridico < Cliente
  has_one :cliente_objeto, :as => :cliente

  def objeto
    cliente_objeto and cliente_objeto.objeto
  end


  # Métodos
  #   Si objeto no especifa los métodos a usar, entonces se espera que tenga definidos los siguientes métodos:
  #   * #nombre
  #   * #cif
  extend Facturacion::Cliente::Individual
  cliente_methods %w(nombre cif)
end
