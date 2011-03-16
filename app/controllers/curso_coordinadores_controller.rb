class CursoCoordinadoresController < ApplicationController
  include Authentication
  before_filter :access_authorized?
  active_scaffold :curso_coordinador do |config|
    # General
    config.label = :label
    config.actions.exclude :update
    
    # List
    config.list.columns = [:nif, :nombre_completo]

    # Create
    config.create.columns = [:coordinador_id]
    config.create.link.inline = true
  end if CursoCoordinador.table_exists?
end
