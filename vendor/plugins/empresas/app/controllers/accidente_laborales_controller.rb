class AccidenteLaboralesController < ApplicationController
  active_scaffold :accidente_laboral do |config|
    #General
    config.list.label = "Control Accidentes Laborales"

    #List
    config.list.columns = [:fecha, :fecha_baja, :fecha_alta]
    config.actions.exclude :show, :search

    #Create
    config.create.columns = [:fecha, :fecha_baja, :fecha_alta, :descripcion]

    #Update 
    config.update.columns = [:fecha, :fecha_baja, :fecha_alta, :descripcion]

  end
end
