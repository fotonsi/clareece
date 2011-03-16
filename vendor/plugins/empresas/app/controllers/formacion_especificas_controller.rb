class FormacionEspecificasController < ApplicationController
  active_scaffold :formacion_especifica do |config|
    #General
    config.list.label = "Formación Específica"

    #List
    config.list.columns = [:nombre, :centro, :fecha]
    config.actions.exclude :show, :search

    #Create
    config.create.columns = [:nombre, :centro, :fecha]

    #Update 
    config.update.columns = [:nombre, :centro, :fecha]

  end
end
