class ClienteFisico < Cliente
  has_one :cliente_objeto, :as => :cliente

  def objeto
    cliente_objeto and cliente_objeto.objeto
  end


  # Métodos
  #   Si objeto no especifica los métodos a usar, entonces se espera que tenga definidos los siguientes métodos:
  #   * #nombre
  #   * #apellidos
  #   * #nombre_completo
  #   * #nif
  extend Facturacion::Cliente::Individual
  cliente_methods %w(nombre apellidos nombre_completo nif)
end
