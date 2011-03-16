class ProvinciasController < ApplicationController
  active_scaffold :provincia do |config|
    # General
    config.label = "Provincias"
    config.actions.exclude :show

    # List
    config.list.columns = [:nombre, :localidades]
    config.list.sorting = [:nombre]

    # Create
    config.create.columns = [:nombre]

    # Update
    config.update.columns = [:nombre]
  end
end
