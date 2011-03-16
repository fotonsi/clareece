class CargosController < ApplicationController
  active_scaffold :cargo do |config|
    # General
    config.label = "Cargos"
    config.actions.exclude :show

    # List
    config.list.columns = [:nombre, :departamento, :definicion, :empleados]
    
    # Create
    config.create.link.page = true
    config.create.columns = [:nombre, :departamento, :dependencia_de, :personal_a_su_cargo, :definicion,
    :funciones_tareas,
    :formacion_general_necesaria, :formacion_especifica_necesaria, :experiencia_requerida, :caracteristicas_personales, :criterio_seleccion, :calificacion,
    :maquinaria, :materiales, :equipos_proteccion_individual,
    :observaciones] #falta Seguridad y Salud Laboral

     # Update
    config.update.link.page = true
    config.update.columns = [:nombre, :departamento, :dependencia_de, :personal_a_su_cargo, :definicion,
    :funciones_tareas,
    :formacion_general_necesaria, :formacion_especifica_necesaria, :experiencia_requerida, :caracteristicas_personales, :criterio_seleccion, :calificacion,
    :maquinaria, :materiales, :equipos_proteccion_individual,
    :observaciones] #falta Seguridad y Salud Laboral
    
  end

  def return_to_main
    redirect_to :action => 'list'
  end

end
