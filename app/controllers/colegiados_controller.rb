class ColegiadosController < ApplicationController
  uses_tiny_mce
  include Authentication
  before_filter :access_authorized?

  active_scaffold :colegiado do |config|
    # General
    config.label = :label
    config.columns[:colegiado_profesiones].show_blank_record = true
    config.columns[:colegiado_especialidades].show_blank_record = true
    config.columns[:importe_deuda].options = {:size => 5, :alt => 'decimal'}
    config.columns[:deuda_a_saldar].options = {:size => 8, :alt => 'decimal'}
    config.columns[:num_cuenta].options = {:alt => 'c_c'}
    config.columns[:cp_titular_cuenta].options = {:size => 5}
    config.columns.add :localidad, :localidad_nacimiento, :banco_id, :apellidos, :pais_id, :pais_residencia_id, :cod_postal, :expediente, :motivo_ingreso_id, :motivo_baja_id, :motivo_ingreso, :motivo_baja, :centro_id, :oficina, :poblacion_banco, :colegiado_profesiones, :colegiado_especialidades
    config.actions.exclude :show, :delete
    config.columns[:apellidos].sort = true
    config.columns[:apellidos].sort_by :sql => "apellido1 || ' ' || apellido2"
    config.columns[:apellidos].search_sql = 'apellido1||apellido2'
    config.search.columns << [:titular]
    #Ponemos esto a vacío para que se dispare el condition_for_localidad_column
    config.columns[:localidad].search_sql = ''

    config.actions.add :field_search
    config.field_search.columns = [:num_colegiado, :nombre, :apellido1, :apellido2, :doc_identidad, :fecha_ingreso, :fecha_baja, :localidad, :situacion_colegial, :situacion_profesional]

    # List
    config.list.columns = [:num_colegiado, :doc_identidad, :apellidos, :nombre, :situacion_colegial, :direccion]

    # Create
    config.create.link.page = true
    config.create.link.label = "Nuevo colegiado"

    # Update
    config.update.label = ""
    config.update.link.page = true

    config.action_links.add 'cursos', 
      :action => 'listar_cursos', 
      :type => :record, 
      :inline => false,
      :icon => {:image => "actions/colegiados/cursos.png", :title => "Cursos"}

    config.action_links.add 'movimientos',
      :action => 'listar_movimientos', 
      :type => :record, 
      :inline => false,
      :icon => {:image => "actions/colegiados/movimientos.png", :title => "Movimientos"}

    config.action_links.add 'informes', 
      :action => 'listar_informes', 
      :type => :record, 
      :inline => false,
      :icon => {:image => "shared/informe.gif", :title => "Informes"}

    config.action_links.add 'expediente', 
      :action => 'expediente', 
      :type => :record, 
      :inline => false,
      :icon => {:image => "actions/colegiados/expediente.png", :title => "Expediente"}

  end if Colegiado.table_exists?
  
  include FieldSearch

  def self.condition_for_fecha_ingreso_column(column, value, like_pattern)
    condition_for_datetime_type(column, value, like_pattern)
  end

  def self.condition_for_fecha_baja_column(column, value, like_pattern)
    condition_for_datetime_type(column, value, like_pattern)
  end

  def self.condition_for_nombre_column(column, value, like_pattern)
    conditions_for_text(value, %w(colegiados.nombre))
  end

  def self.condition_for_apellido1_column(column, value, like_pattern)
    conditions_for_text(value, %w(colegiados.apellido1))
  end

  def self.condition_for_apellido2_column(column, value, like_pattern)
    conditions_for_text(value, %w(colegiados.apellido2))
  end

  def self.condition_for_localidad_column(column, value, like_pattern)
    conditions_for_text(value, %w(localidad))
  end

  # AS no hace nada cuando en el params no llega ningún registro de la asociación.
  #def before_update_save(record)
  #  %w(profesiones especialidades).each{|asociacion|
  #    #FIXME, el disabled en baja_colegial hace que no venga en params[:record], luego lo borra.
  #    if params[:record]["colegiado_#{asociacion}"] && params[:record]["colegiado_#{asociacion}"].blank?
  #      record.send("colegiado_#{asociacion}").clear
  #    end
  #  }
  #end

  # Editamos tras crear.
  def local_after_create_save(record)
    flash[:notice] = "Colegiado creado correctamente"
    local_after_update_save(record)
    #redirect_to :action => 'edit', :id => record
  end

  def redirect_after_save(id)
    redirect_to :action => 'edit', :id => id
  end

  # Recargamos tras editar.
  def local_after_update_save(record)
    #PONER AQUÍ LA LLAMADA A colegiado.procesar_alta o colegiado.procesar_baja comparando con situacion_colegial_orig
    begin
      if params['record_situacion_colegial_orig'] != params['record']['situacion_colegial']
        if params['record']['situacion_colegial'] == 'colegiado'
          result = record.procesar_alta
          msg = "Proceso de alta completado"
        elsif params['record']['situacion_colegial'] == 'colegiado_no_ejerciente'
          result = record.procesar_no_ejerciente
          msg = "Colegiado cambiado a 'No ejerciente'"
        elsif params['record']['situacion_colegial'] == 'baja_colegial'
          result = record.procesar_baja
          msg = "Proceso de baja completado"
        end
        flash[:notice] = "#{msg}#{' ('+result[:msg]+')' unless result[:msg].blank?}"
      else
        msg = "Colegiado actualizado correctamente"
        flash[:notice] = msg
      end
    rescue Exception => e
      if msg == "Colegiado actualizado correctamente"
        msg = "Ocurrió algún problema al actualizar el colegiado"
      else
        msg.gsub!("completado", "con errores") if msg
      end
      flash[:error] = "#{msg}: #{e.message}"
    end
    #redirect_to :action => 'edit', :id => record
  end

  def listar_cursos
    @record = Colegiado.find(params[:id])
  end

  def listar_recibos
    @record = Colegiado.find(params[:id])
  end

  def listar_movimientos
    @record = Colegiado.find(params[:id])
  end

  def listar_remesas
    @record = Colegiado.find(params[:id])
  end

  def listar_informes
    @record = Colegiado.find(params[:id])
    @informes = Informe.find(:all, :order => 'nombre', :conditions => ['objeto = ?', @record.class.to_s.downcase])
  end

  def expediente
    record = Colegiado.find(params[:id])
    redirect_to :controller => 'expedientes', :action => 'edit', :id => record.expediente if record.expediente
  end

  def provincia_cambia
    prov = Provincia.find(params[:provincia_id])
    locs = prov.localidades.sort_by {|l| l.nombre}
    if params[:modo]
      locs2 = {}
      locs.each {|l| locs2[l.nombre] ||= []; locs2[l.nombre] << l}
      render :update do |page|
        page.replace_html "record_localidad#{'_'+params[:modo] if params[:modo]}_id", (['<option value="">-- seleccione localidad --</option>']+locs2.keys.sort.map {|l| %|<option value="#{locs2[l].first[:id]}">#{locs2[l].first[:nombre]}</option>| })
      end
    else
      render :update do |page|
        page.replace_html "record_localidad#{'_'+params[:modo] if params[:modo]}_id",
          options_for_select([['-- seleccione localidad --', nil]]+
            locs.map do |l|
             ["#{l.nombre} - #{l.cp.to_s.rjust(5, '0')}", l.id]
            end)
      end
    end
  end

  def pais_cambia
    pais = Pais.find(params[:pais_id])
    provs = pais.provincias.sort_by {|pr| pr.nombre}
    render :update do |page|
      page.replace_html 'provincia_nacimiento', (['<option value="">-- seleccione provincia --</option>']+provs.map {|pr| %|<option value="#{pr.id}">#{pr.nombre}</option>| })
    end
  end
end
