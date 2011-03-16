class ExpedienteGestion < ActiveRecord::Base
  belongs_to :expediente
  belongs_to :gestion_documental
  has_many :etiquetas, :dependent => :destroy, :class_name => 'ExpedienteGestionEtiqueta'
end
