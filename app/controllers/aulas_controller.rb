class AulasController < ApplicationController
  include Authentication
  before_filter :access_authorized?

  active_scaffold :aula do |config|
    # General
    config.actions.exclude :show

    # List
    config.list.columns = [:nombre, :capacidad, :cursos]

    # Create
    config.create.columns = [:nombre, :capacidad]

    # Update
    config.update.columns = [:nombre, :capacidad]
  end if Aula.table_exists?
end
