class ProfesoresController < ApplicationController
  include Authentication
  before_filter :access_authorized?
  active_scaffold :profesor do |config|
    # General
    config.actions.exclude :show
    form_columns = [:nombre, :apellido1, :apellido2, :tipo_doc_identidad, :doc_identidad, :localidad_id, :email, :num_cuenta]
    config.columns[:num_cuenta].options = {:size => 20, :alt => 'c_c'}

    # List
    config.list.columns = [:nombre_completo, :doc_identidad]

    # Create
    config.create.columns = form_columns 
    config.create.link.page = true

    # Update
    config.update.columns = form_columns
    config.update.link.page = true
  end if Profesor.table_exists?

  include FieldSearch
end
