class AddToCargos < ActiveRecord::Migration
  def self.up
    add_column :cargos, :departamento, :string
    add_column :cargos, :dependencia_de, :string
    add_column :cargos, :personal_a_su_cargo, :string
    add_column :cargos, :definicion, :string
    add_column :cargos, :funciones_tareas, :text

    add_column :cargos, :formacion_general_necesaria, :string
    add_column :cargos, :formacion_especifica_necesaria, :string
    add_column :cargos, :experiencia_requerida, :string
    add_column :cargos, :caracteristicas_personales, :string
    add_column :cargos, :criterio_seleccion, :string
    add_column :cargos, :clasificacion, :string

    add_column :cargos, :maquinaria, :string
    add_column :cargos, :materiales, :string
    add_column :cargos, :equipos_proteccion_individual, :string

    add_column :cargos, :observaciones, :text
  end

  def self.down
    remove_column :cargos, :departamento
    remove_column :cargos, :dependencia_de
    remove_column :cargos, :personal_a_su_cargo
    remove_column :cargos, :definicion
    remove_column :cargos, :funciones_tareas

    remove_column :cargos, :formacion_general_necesaria
    remove_column :cargos, :formacion_especifica_necesaria
    remove_column :cargos, :experiencia_requerida
    remove_column :cargos, :caracteristicas_personales
    remove_column :cargos, :criterio_seleccion
    remove_column :cargos, :clasificacion

    remove_column :cargos, :maquinaria
    remove_column :cargos, :materiales
    remove_column :cargos, :equipos_proteccion_individual

    remove_column :cargos, :observaciones
  end
end
