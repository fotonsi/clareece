class SedesController < ApplicationController
  active_scaffold :sede do |config|
    # List
    config.label = "Sedes"
    config.list.columns = [:empresa, :nombre, :localidad_id, :empleados] 
    config.columns[:nombre].label = "Sede"
    config.actions.exclude :show, :search

    # Create
    config.create.columns = [:empresa, :nombre, :localidad_id, :direccion, :telefono1, :telefono2, :fax]

    # Update
    config.update.columns = [:empresa, :nombre, :localidad_id, :direccion, :telefono1, :telefono2, :fax]

  end

end
