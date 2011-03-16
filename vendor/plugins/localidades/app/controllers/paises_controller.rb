class PaisesController < ApplicationController
  active_scaffold :pais do |config|
    # General
    config.label = "Países"
    config.actions.exclude :show

    # List
    config.list.columns = [:nombre, :provincias]
    config.list.sorting = [:nombre]

    # Create
    config.create.columns = [:nombre]

    # Update
    config.update.columns = [:nombre]
  end
end
