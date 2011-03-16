class ProfesionesController < ApplicationController
  include Authentication
  before_filter :access_authorized?
  active_scaffold :profesion do |config|
    config.columns.exclude :colegiado_profesiones
  end if Profesion.table_exists?
end
