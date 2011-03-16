class CursoProfesoresController < ApplicationController
  include Authentication
  before_filter :access_authorized?
  active_scaffold :curso_profesor do |config|
    # General
    config.label = :label
    config.actions.exclude :update
    
    # List
    config.list.columns = [:nif, :nombre_completo]

    # Create
    config.create.columns = [:profesor_id]
    config.create.link.inline = true
  end if CursoProfesor.table_exists?
end
