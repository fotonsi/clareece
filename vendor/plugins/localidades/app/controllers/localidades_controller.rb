class LocalidadesController < ApplicationController
  active_scaffold :localidad do |config|
    # General
    config.label = "Localidades"
    config.actions.exclude :show
    form_columns = [:nombre, :cp]

    # List
    config.list.columns = [:nombre, :cp]
    config.list.sorting = [:nombre]

    # Create
    config.create.columns = form_columns 

    # Update
    config.update.columns = form_columns
  end
end
