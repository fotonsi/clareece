class ColegiadoEspecialidadesController < ApplicationController
  include Authentication
  before_filter :access_authorized?
  active_scaffold :colegiado_especialidad do |config|
    config.label = ""
    config.columns[:especialidad].label = ""
  end if ColegiadoEspecialidad.table_exists?
end
