class FormacionAcademicasController < ApplicationController
  active_scaffold :formacion_academica do |config|
    #General
    config.list.label = "Formación Académica"

    #List
    config.list.columns = [:titulacion, :fecha]
    config.actions.exclude :show, :search

    #Create
    config.create.columns = [:titulacion, :fecha]

    #Update 
    config.update.columns = [:titulacion, :fecha]

  end
end
