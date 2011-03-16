class ColegiadoProfesionesController < ApplicationController
  include Authentication
  before_filter :access_authorized?
  active_scaffold :colegiado_profesion do |config|
    config.label = ""
    config.columns[:profesion].label = ""
  end if ColegiadoProfesion.table_exists?
end
