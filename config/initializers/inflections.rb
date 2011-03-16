# Be sure to restart your server when you modify this file.

# Add new inflection rules using the following format 
# (all these examples are active by default):
# ActiveSupport::Inflector.inflections do |inflect|
#   inflect.plural /^(ox)$/i, '\1en'
#   inflect.singular /^(ox)en/i, '\1'
#   inflect.irregular 'person', 'people'
#   inflect.uncountable %w( fish sheep )
# end
ActiveSupport::Inflector.inflections do |inflect|  # Obtenidas de http://buscon.rae.es/dpdI/SrvltGUIBusDPD?lema=plural
  inflect.plural /^(.*[nlrds])$/i, '\1es'
  inflect.singular /^(.*[nlrds])es$/i, '\1'
  inflect.irregular "sede", "sedes"
  inflect.irregular "detalle", "detalles"
  inflect.irregular 'gestion_documental', 'gestiones_documentales'
  inflect.irregular 'GestionDocumental', 'GestionesDocumentales'
  inflect.irregular 'expediente_gestion', 'expedientes_gestiones'
  inflect.irregular 'ExpedienteGestion', 'ExpedientesGestiones'
  inflect.irregular 'EntidadAcreditadora', 'EntidadesAcreditadoras'
  inflect.irregular 'entidad_acreditadora', 'entidades_acreditadoras'
  inflect.irregular 'CajaCuadre', 'CajaCuadres'
  inflect.irregular 'caja_cuadre', 'caja_cuadres'
end
