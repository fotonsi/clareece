class FormacionesController < ApplicationController

  include Authentication
  before_filter :access_authorized?
  # Modos de listado:
  # * alumnos: se llama desde cursos para los matriculados.
  # * lista_espera: se llama desde cursos para la lista de espera.
  # * cursos: se llama desde colegiados.

  before_filter :update_table_config

  @@form_columns = [:estado, :colegiado_id, :curso_id, :forma_pago, :nota, :apto, :observaciones]
  active_scaffold :formacion do |config|
    # General
    config.actions.exclude :show
    config.actions.exclude :delete
    config.columns.add :colegiado_id, :curso_id
    config.columns[:alumno].clear_link
    config.columns[:curso].clear_link
    config.columns[:observaciones].options = {:cols => 30, :rows => 3}

    # List
    config.list.columns = [:alumno, :curso, :estado, :created_at, :apto, :asistencia, :forma_pago, :movimientos]
    config.list.sorting = {:created_at => :desc}

    # Create
    config.create.link.inline = true
    config.create.label = ""
    config.create.link.label = "Nuevo alumno"
    config.create.columns = @@form_columns 

    # Update
    config.update.label = ""
    config.update.link.security_method = :record_update_authorized?
    config.update.link.page = true

    # Search
    config.actions.add :field_search
    config.columns[:alumno].search_sql = "" # Necesita que no sea nil para que se llame al método condition_for_titular_column
    config.field_search.columns = [:alumno, :created_at, :forma_pago, :estado]

    # Delete
    #config.delete.link.security_method = :record_delete_authorized?

    # New actions
    config.action_links.add 'matricular', 
      :action => 'matricular', 
      :type => :record, 
      :inline => false,
      :icon => {:image => "actions/formaciones/matricular.png", :title => "Matricular este alumno"},
      :confirm => I18n.t('active_scaffold.formaciones.matricular_confirm')

    config.action_links.add 'baja_matricula', 
      :action => 'baja_matricula', 
      :type => :record, 
      :inline => false,
      :icon => {:image => "actions/borrar.gif", :title => "Cancelar la matricula de este alumno"},
      :confirm => I18n.t('active_scaffold.formaciones.baja_matricula_confirm')

    config.action_links.add 'devolver_matricula', 
      :action => 'devolver_matricula', 
      :type => :record, 
      :inline => false,
      :icon => {:image => "shared/movimientos.png", :title => "Devolver la matricula de este alumno"},
      :confirm => I18n.t('active_scaffold.formaciones.devolver_matricula_confirm')

    config.action_links.add 'recibo_matricula',
      :action => 'recibo_matricula',
      :type => :record,
      :inline => true,
      :position => false,
      :icon => {:image => "actions/movimientos/recibo_cuota.png", :title => "Recibo matrícula"}
   end if Formacion.table_exists?

  def before_create_save(record) 
    if record.curso.precio_matricula > 0
      record.asociar_movimiento #Se paga sea reserva o matrícula
      if record.movimientos.empty?
        flash[:error] = "Falló la creación de los movimientos (error: #{record.errors.full_messages}), por favor introdúzcalos manualmente."
      end
    end
  end

  def after_create_save(record)
    if record.matriculado?
      #TODO Email al alumno notificando la matrícula
    end
  end

  def after_update_save(record)
    return_to_main
  end

  def return_to_main
    flash[:notice] = "Datos guardados correctamente"
    redirect_to :action => 'edit', :id => @record
  end

  def update_table_config
    matricular_link = active_scaffold_config.action_links.detect{|i| i.action == 'matricular'}
    if params[:embedded] == "colegiados"
      active_scaffold_config.create.columns.exclude @@form_columns
      active_scaffold_config.create.columns.add [:estado, :curso_id, :forma_pago, :observaciones]
    else
      active_scaffold_config.create.columns.exclude @@form_columns
      columns = [:estado, :colegiado_id, :forma_pago, :observaciones]
      active_scaffold_config.create.columns.add columns
      active_scaffold_config.list.columns.exclude(:nota, :asistencia) if params[:list] == "lista_espera"
      active_scaffold_config.list.columns.add(:nota, :asistencia) if params[:list] != "lista_espera"
    end

  end

    # Search

  include FieldSearch
  
  def self.condition_for_alumno_column(column, value, like_pattern)
    if value =~ /^#\d+$/
      conds = conditions_for_text(value[1..-1], %w(num_colegiado))
      ids = ActiveRecord::Base.connection.select_all("select id from colegiados where num_colegiado = #{value[1..-1]}").map{|i| i['id'].to_i}
    else
      conds = conditions_for_text(value, %w(nombre apellido1 apellido2 doc_identidad))
      ids = ActiveRecord::Base.connection.select_all("select id from colegiados where #{conds}").map{|i| i['id'].to_i}
    end
    ["alumno_type = ? and alumno_id in (?)", 'Colegiado', ids]
  end

  def self.condition_for_created_at_column(column, value, like_pattern)
    condition_for_datetime_type(column, value, like_pattern)
  end

  # authorized

  def record_update_authorized?(record)
    not record.espera?
  end

  def record_delete_authorized?(record)
    record.curso.estado == 'sin_iniciar'
  end

  def asistencia_authorized?
    params[:list] == "alumnos"
  end

  def matricular_authorized?(record)
    record.espera?
  end

  def baja_matricula_authorized?(record)
    record.curso.estado == 'sin_iniciar' && record.estado != 'baja'
  end

  public

  def baja_matricula
    @record = Formacion.find(params[:id])
    flash[:notice] = "Baja realizada. Se ha anulado el cargo de la matrícula. Si se efectuó el pago de la misma, deberá realizar la devolución correspondiente en caso necesario."
    begin
      @record.baja!
    rescue Exception => e
      flash[:notice] = nil
      flash[:error] = e.message
    end
    #TODO Email al alumno notificando la baja
    redirect_to :back
  end

  def devolver_matricula
    @record = Formacion.find(params[:id])
    begin
      @record.devolucion!
    rescue Exception => e
      flash[:notice] = nil
      flash[:error] = e.message
    end
    #TODO Email al alumno notificando la baja
    redirect_to :back
  end

  def matricular
    @record = Formacion.find(params[:id])
    if @record.curso.posible_matricular?
      @record.estado = :matriculado.to_s
      @record.save
      if @record.valid?
        flash[:notice] = "Alumno matriculado correctamente."
        #TODO Email al alumno notificando la matrícula
      else
        flash[:error] = @record.matricular_validations
      end
    else
      flash[:error] = @record.matricular_validations
    end
    redirect_to :back
  end

  def asistencia 
    @formacion_id = params[:formacion_id]
    @formacion = @record = Formacion.find(@formacion_id)
    @curso = @formacion.curso
    @turnos = @curso.turnos
    if request.get?
    else
      asist = params[:seleccionado]
      @curso.ausencias.find_all_by_alumno_id_and_alumno_type(@formacion.alumno_id, @formacion.alumno_type).each {|a| a.destroy}
      @curso.turnos.each do |fecha, horas|
        if !asist["#{@formacion.alumno.id}_#{@formacion.alumno_type}"] || !asist["#{@formacion.alumno.id}_#{@formacion.alumno_type}"][fecha.strftime("%Y-%m-%d")] || !asist["#{@formacion.alumno.id}_#{@formacion.alumno_type}"][fecha.strftime("%Y-%m-%d")][horas[0]]
          a = Ausencia.new(:fecha => fecha, :turno => horas[0])
          a.curso = @curso
          a.alumno = @formacion.alumno_type.camelize.constantize.find(@formacion.alumno_id)
          a.save!
        end
      end
      flash[:notice] = "Actualizado el control de asistencia"
      redirect_to :action => 'asistencia', :id => @formacion
    end
  end

  def genera_contrato
    begin
      informe = Informe.find_by_nombre('Contrato curso')
      if informe.nil?
        render :update do |page|
          page << "alert('El formulario de matrícula no está dado de alta en como plantilla (id: #{params[:id]})');"
        end
        return
      end
      formacion = Formacion.find(params[:id])
      if formacion.nil?
        render :update do |page|
          page << "alert('La matrícula que se desea imprimir no existe (#{formacion} id: #{params[:formacion_id]})');"
        end
        return
      end
      gd = informe.obtener_para(formacion)
      titulo = Titulo.create(:fecha => Date.today, :formacion_id => formacion.id)
      render :update do |page|
        page << "alert('El número de registro de #{gd.tipo} es el #{gd.num_registro}')"
        page.redirect_to :controller => 'informes', :action => 'send_xml', :id => gd.documento.id
      end
    rescue Exception => e
      render :update do |page|
        page << %|alert('Se produjo un error al generar el contrato para la matrícula con id #{id}: ' + #{e.message.to_json});|
      end
    end
  end

  def genera_diplomas
    begin
      formacion = Formacion.find(params[:id])
      #En este momento pasamos true porque queremos simplemente imprimirlo
      titulo = formacion.genera_diploma
      render :update do |page|
        page << %|alert('Se registró título núm. #{titulo.id}')|
      end
    rescue Exception => e
      render :update do |page|
        page << %|alert('Se produjo un error al generar el diploma: ' + #{e.message.to_json});|
      end
    end
  end

  def recibo_matricula
    matricula = Formacion.find(params[:id])
    redirect_to :controller => 'informes', :action => 'parsea', :id => Informe.find_by_objeto('curso_alumno'), :objeto_id => params[:id]
  end
end
