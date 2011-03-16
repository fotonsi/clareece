class CursoAcreditacionesController < ApplicationController
  include Authentication
  before_filter :access_authorized?
  active_scaffold :curso_acreditacion do |config|
    # General
    config.columns[:entidad_acreditadora_id].options = {:size => 15}
    config.columns[:creditos].options = {:size => 4, :alt => 'decimal'}
    config.columns[:codigo].options = {:size => 15}

    # Create y Update
    config.create.columns = config.update.columns = [:entidad_acreditadora, :creditos, :codigo, :fecha_solicitud, :fecha_obtencion]
  end if CursoAcreditacion.table_exists?
end
