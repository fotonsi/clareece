class EspecialidadesController < ApplicationController
  include Authentication
  before_filter :access_authorized?
  active_scaffold :especialidad do |config|
    config.columns.exclude :colegiado_especialidades
  end if Especialidad.table_exists?
end
