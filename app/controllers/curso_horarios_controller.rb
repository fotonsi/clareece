class CursoHorariosController < ApplicationController
  include Authentication
  before_filter :access_authorized?
  active_scaffold :curso_horario do |config|
    # General

    # Create y Update
    config.create.columns = config.update.columns = [:fecha_ini, :fecha_fin, :hora_ini, :hora_fin]
  end if CursoHorario.table_exists?
end
