class ExperienciaProfesionalesController < ApplicationController
  active_scaffold :experiencia_profesional do |config|
    #General
    config.list.label = "Experiencia Profesional Anterior"

    #List
    config.list.columns = [:empresa, :puesto_trabajo, :fecha_inicio, :tiempo_permanencia]
    config.actions.exclude :show, :search

    #Create
    config.create.columns = [:empresa, :puesto_trabajo, :fecha_inicio, :tiempo_permanencia]

    #Update 
    config.update.columns = [:empresa, :puesto_trabajo, :fecha_inicio, :tiempo_permanencia]

  end
end
