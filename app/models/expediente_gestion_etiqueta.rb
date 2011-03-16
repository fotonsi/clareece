class ExpedienteGestionEtiqueta < ActiveRecord::Base
  belongs_to :expediente_gestion

  def self.etiquetas_existentes
    lista = connection.execute "select count(etiqueta) as num, etiqueta as nombre from expediente_gestion_etiquetas group by etiqueta;"
    return lista unless lista.none?
  end

  def to_label
    etiqueta
  end
end
