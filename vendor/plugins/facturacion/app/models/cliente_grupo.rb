class ClienteGrupo < Cliente
  has_many :cliente_objetos, :as => :cliente

  def objetos
    cliente_objetos.map{|i| i.objeto}
  end

end
