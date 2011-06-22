class GestionesDocumentalesController < ApplicationController

  include Authentication
  before_filter :access_authorized?
  before_filter :update_table_config, :save_active_scaffold_session
  
  active_scaffold :gestion_documental do |config|
    # General
    config.label = :label
    config.actions.exclude :show
    config.columns[:documento].clear_link
    config.columns.add :uploaded_data, :documento_id
    config.columns.add :num_registro
    config.columns[:num_registro].css_class = 'no-numeric'
    form_columns = [:tipo, :created_at, :destinatario, :direccion_destinatario, :remitente, :direccion_remitente, :texto, :uploaded_data, :documento_id, :observaciones, :etiquetas]

    # List
    config.list.columns = [:num_registro, :created_at, :tipo, :texto, :remitente, :destinatario, :etiquetas]
    config.list.sorting = {:id => :desc}

    # Create
    config.create.link.page = true
    config.create.multipart = true
    config.create.columns = form_columns
    config.create.label = ""

    # Update
    config.update.link.page = true
    config.update.multipart = true
    config.update.columns = form_columns
    config.update.label = ""

    # Search
    config.actions.add :field_search
    config.field_search.columns = [:num_registro, :created_at, :tipo, :documento, :destinatario, :remitente, :texto, :observaciones]
    config.columns[:documento].search_sql = 'documentos.filename'

    # New actions
    
    config.action_links.add 'new_salida', 
      :action => 'new', 
      :parameters => {:tipo => 'salida'},
      :type => :record, 
      :inline => true,
      :position => :after,
      :icon => {:image => "actions/gestiones_documentales/salida.png", :title => "Generar salida del documento"},
      :confirm => as_('new_salida_confirm')

    # Acciones para relacionar con los expedientes
    config.action_links.add 'crear_existente', 
      :action => 'crear_existente', 
      :label => :crear_existente,
      :type => :table, 
      :inline => true,
      :position => :top

    config.action_links.add 'quitar_asociacion_expediente', 
      :action => 'quitar_asociacion_expediente', 
      :type => :record, 
      :inline => true,
      :position => false,
      :icon => {:image => "actions/gestiones_documentales/quitar_asociacion.png", :title => "Desasociar este documento"},
      :confirm => as_('quitar_asociacion_expediente_confirm')
  
  end if GestionDocumental.table_exists?

  def return_to_main
    if %w(new create).include? params[:action]
      flash[:notice] = "Número de registro generado. Seleccione el documento adjunto."
      redirect_to :action => 'edit', :id => @record
    else
      redirect_to :action => 'index'
    end
  end

  def save_active_scaffold_session
    if params[:embedded] == "expedientes" 
      expediente = Expediente.find(params[:expediente_id])
      active_scaffold_session_storage[:conditions] = ["gestiones_documentales.id in (?)", expediente.gestion_documental_ids]
    end
  end

  def update_table_config
    if params[:embedded] == "expedientes"
      active_scaffold_config.action_links.detect{|i| i.label == 'new_salida'}.type = false
      active_scaffold_config.delete.link.type = false
      active_scaffold_config.search.link.type = false
      active_scaffold_config.action_links.detect{|i| i.label == 'quitar_asociacion_expediente'}.type = :record
      active_scaffold_config.action_links.detect{|i| i.label == as_(:crear_existente)}.type = :table
    else
      active_scaffold_config.action_links.detect{|i| i.label == 'new_salida'}.type = :record 
      active_scaffold_config.delete.link.type = :record 
      active_scaffold_config.search.link.type = :table 
      active_scaffold_config.action_links.detect{|i| i.label == 'quitar_asociacion_expediente'}.type = false
      active_scaffold_config.action_links.detect{|i| i.label == as_(:crear_existente)}.type = false
    end
  end

  # Se crea modifica para asignar el tipo y el documento cuando es una salida.
  def do_new
    @record = active_scaffold_config.model.new
    apply_constraints_to_record(@record)
    @record.tipo = params[:tipo] # tipo
    @record.documento = GestionDocumental.find(params[:id]).documento if params[:id] && @record.salida? # documento
    params.delete :tipo
    params[:eid] = @old_eid if @remove_eid
    @record
  end

  def download
    documento = Documento.find(params[:id])
    send_file documento.full_filename, :type => documento.content_type, :file_name => documento.filename
  end

  include FieldSearch

  def self.condition_for_created_at_column(column, value, like_pattern)
    condition_for_datetime_type(column, value, like_pattern)
  end

  def self.condition_for_documento_column(column, value, like_pattern)
    conditions_for_text(value, %w(documentos.filename))
  end

  def self.condition_for_destinatario_column(column, value, like_pattern)
    conditions_for_text(value, %w(destinatario))
  end

  def self.condition_for_remitente_column(column, value, like_pattern)
    conditions_for_text(value, %w(remitente))
  end

  def self.condition_for_texto_column(column, value, like_pattern)
    conditions_for_text(value, %w(texto))
  end

  def self.condition_for_observaciones_column(column, value, like_pattern)
    conditions_for_text(value, %w(observaciones))
  end

  # Acciones para asociar gestiones documentales con expedientes
  def asociar_expediente(record)
    # Se asocia la nueva gestión documental al expediente
    if (expediente = Expediente.find_by_id(params[:expediente_id])) && !ExpedienteGestion.find(:first, :conditions => ['gestion_documental_id = ? and expediente_id = ?', record.id, expediente.id])
      eg = ExpedienteGestion.create(:gestion_documental => record, :expediente => expediente)
    end
  end

  def local_after_create_save(record)
    asociar_expediente record
  end

  def local_after_update_save(record)
    if d = record.documento
      d.tag_list = params['etiquetas']
      d.save
    end
    asociar_expediente record
  end
  
  def redirect_after_save(id)
    if params[:action] == 'create' && params[:embedded] && params[:expediente_id]
      redirect_to :controller => 'gestiones_documentales', :action => 'edit', :id => id, :expediente_id => params[:expediente_id], :embedded => params[:embedded]
    elsif params[:expediente_id]
      redirect_to :controller => 'expedientes', :action => 'edit', :id => params[:expediente_id]
    else
      redirect_to :controller => 'gestiones_documentales', :action => 'index'
    end
  end

  def crear_existente
    if request.post?
      if gd = GestionDocumental.find_by_id(params[:record][:gestion_documental_id])
        expediente = Expediente.find(params[:expediente_id]) if params[:expediente_id]
        eg = ExpedienteGestion.create(:gestion_documental => gd, :expediente => expediente)
      end
      render :update do |page|
        page << "active_scaffold_update();"
      end
    end
  end

  def quitar_asociacion_expediente
    @record = GestionDocumental.find(params[:id])
    @record.expedientes_gestiones.each {|eg| eg.destroy if eg.expediente_id == params[:expediente_id].to_i }
    render :update do |page|
      page << "active_scaffold_update();"
    end
  end

  def etiquetas_auto_complete
    exp = Expediente.find(params[:expediente_id]) if params[:expediente_id]
    etiquetas = exp ? (exp.etiquetas_obligatorias(true) + exp.etiquetas_optativas(true)) : []
    etiquetas += Documento.tag_counts.map {|ee| ee[:name].to_sym} if params[:val] != '#'
    etiquetas.uniq!
    etiquetas = etiquetas.map {|e| e.to_s}
    etiquetas = params[:val] != '#' ? etiquetas.grep(Regexp.new("^#{params[:val]}")) : etiquetas
    etiquetas.reject! {|e| exp.tiene_doc?(e)} if params[:val] == '#'
    render :text => '<ul>'+etiquetas.map {|e| "<li>#{e}</li>"}.join("")+'</ul>'
  end


  # AS authorized

  def new_salida_authorized?(record)
    record.authorized_for_create_salida?
  end

  def crear_existente_authorized?
    current_user.tiene_permiso_para?('new_gestiones_documentales')
  end

  def quitar_asociacion_expediente_authorized?(record)
    current_user.tiene_permiso_para?('edit_gestiones_documentales')
  end

  def update_authorized?
    current_user.tiene_permiso_para?('edit_gestiones_documentales')
  end

  def create_authorized?
    current_user.tiene_permiso_para?('new_gestiones_documentales')
  end

end
