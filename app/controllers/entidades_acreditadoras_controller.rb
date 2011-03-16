class EntidadesAcreditadorasController < ApplicationController
  include Authentication
  before_filter :access_authorized?
  active_scaffold :entidad_acreditadora do |config|
    config.columns.exclude :acreditaciones
    config.label = :label
  end if EntidadAcreditadora.table_exists?
end
