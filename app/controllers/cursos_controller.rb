class CursosController < ApplicationController
  include Authentication
  before_filter :access_authorized?
  uses_tiny_mce

  active_scaffold :curso do |config|
    # General
    config.columns.add :aula_id
    config.label = "cursos.label" 
    config.columns[:horarios].show_blank_record = true
    config.columns[:acreditaciones].show_blank_record = false
    config.columns[:precio_matricula].options = {:size => 5, :alt => 'decimal'}
    config.columns[:id].options = {:size => 10, :readonly => true, :class => 'text-input readonly'}
    config.columns[:aula_id].options = {:size => 60}
    config.columns[:num_plazas_max].options = {:size => 3, :alt => 'integer'}
    config.columns[:num_plazas_min].options = {:size => 3, :alt => 'integer'}
    config.columns[:num_plazas_presenciales].options = {:size => 3, :alt => 'integer'}
    config.columns[:num_horas_presenciales].options = {:size => 3, :alt => 'decimal'}
    config.columns[:num_horas_virtuales].options = {:size => 3, :alt => 'decimal'}
    config.columns[:porc_asistencia_minima].options = {:size => 2, :alt => 'integer'}
    config.columns[:descripcion].form_ui = :textarea
    config.columns[:nombre].options = {:size => 80}
    config.columns[:descripcion].options = {:rows => 3, :cols => 40}
    config.columns[:observaciones].options = {:rows => 3, :cols => 40}
    config.actions.exclude :show

    config.actions.add :field_search
    config.field_search.columns = [:nombre, :codigo, :estado, :fecha_ini, :fecha_fin, :aula]
    config.columns[:aula].search_sql = ''

    # List
    config.list.columns = [:id, :nombre, :estado, :fecha_ini, :fecha_fin, :alumnos, :lugar]

    # Create
    config.create.columns.add :horarios
    config.create.columns.add :acreditaciones
    config.create.link.page = true

    # Update
    config.update.label = ""
    config.update.columns.add :horarios
    config.update.columns.add :acreditaciones
    config.update.link.page = true

    # Delete
    config.delete.link.security_method = :record_delete_authorized?
  end if Curso.table_exists?

  def asistencia 
    @curso_id = params[:id]
    @record = Curso.find(@curso_id)
    @formaciones = Formacion.find_all_by_curso_id(@curso_id)
    @turnos = Curso.find(@curso_id).turnos
    if request.get?
    else
      asist = params[:seleccionado]
      curso = @record
      curso.ausencias.clear
      curso.formaciones.each do |f|
        curso.turnos.each do |fecha|
          fecha[1].each do |hora|
            if !asist["#{f.alumno.id}_#{f.alumno_type}"] || !asist["#{f.alumno.id}_#{f.alumno_type}"][fecha[0].strftime("%Y-%m-%d")] || !asist["#{f.alumno.id}_#{f.alumno_type}"][fecha[0].strftime("%Y-%m-%d")][hora]
              a = Ausencia.new(:fecha => fecha[0], :turno => hora)
              a.curso = curso
              a.alumno = f.alumno_type.camelize.constantize.find(f.alumno_id)
              a.save!
            end
          end
        end
      end
      flash[:notice] = "Actualizado el control de asistencia"
      redirect_to :action => 'asistencia', :id => @record
    end
  end
 
  include FieldSearch

  def self.condition_for_fecha_ini_column(column, value, like_pattern)
    condition_for_datetime_type(column, value, like_pattern)
  end

  def self.condition_for_fecha_fin_column(column, value, like_pattern)
    condition_for_datetime_type(column, value, like_pattern)
  end

  def self.condition_for_nombre_column(column, value, like_pattern)
    conditions_for_text(value, %w(cursos.nombre))
  end

  def self.condition_for_aula_column(column, value, like_pattern)
    conditions_for_text(value, %w(aulas.nombre))
  end

  protected

  # AS no hace nada cuando en el params no llega ningún registro de la asociación.
  def before_update_save(record)
    record.horarios.clear if params[:record][:horarios].blank?
    # AS pasa de ciertos tipos de campo como los date para detectar si un has_many estaba en blanco o no
    #   (vendor/plugins/active_scaffold/lib/active_scaffold/attribute_params.rb l. 171)
    #   lo creamos aquí a mano.
    params[:record][:horarios].each do |rhk, rhv|
      next unless (!rhv["fecha_ini"].blank? || !rhv["fecha_fin"].blank?) && (rhv["hora_ini"].blank? && rhv["hora_fin"].blank?)
      record.horarios << CursoHorario.new(rhv)
    end
    #record.num_horas = record.duracion_horas
    record.acreditaciones.clear if params[:record][:acreditaciones].blank?
  end

  def before_create_save(record)
    before_update_save(record)
  end

  # Editamos tras crear.
  def after_create_save(record)
    flash[:notice] = "Curso creado correctamente"
    redirect_to :action => 'edit', :id => record
  end

  def after_update_save(record)
    flash[:notice] = "Curso actualizado correctamente"
    redirect_to :action => 'edit', :id => record
  end

  # authorized

  def record_delete_authorized?(record)
    record.formaciones.count == 0
  end

  public

  [:listar_alumnos, :lista_espera, :listar_profesores, :listar_coordinadores].each do |metodo|
    class_eval <<-EOC
      def #{metodo.to_s}
        @record = Curso.find(params[:id])
      end
    EOC
  end

  def notificar_curso
    #TODO email de notificación del celebración del curso
    flash[:error] = "No está desarrollado el envío de email"
    redirect_to :back
  end

  def cancelar_curso
    @record = Curso.find(params[:id])
    @record.cancelar!
    #TODO email a los matriculados para avisar la cancelación del curso
    flash[:notice] = "Curso cancelado correctamente"
    redirect_to :back
  end

  def acta_curso
    @record = Curso.find(params[:id])
    if @record.acta!
      #TODO email a cada alumno con la nota
      flash[:notice] = "Acta realizada correctamente"
    else
      flash[:error] = "No se ha podido realizar el acta del curso"
    end
    redirect_to :back
  end

end
