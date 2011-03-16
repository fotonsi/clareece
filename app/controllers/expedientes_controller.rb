class ExpedientesController < ApplicationController

  include Authentication
  before_filter :access_authorized?
  before_filter :update_table_config, :save_active_scaffold_session

  active_scaffold :expediente do |config|
    # General
    config.label = :label
    config.columns[:titulo].options = {:size => "50%"}
    config.columns[:descripcion].options = {:rows => 10, :cols => "70%"}
    config.columns[:fecha_apertura].form_ui = :calendar_date_select
    config.columns[:fecha_cierre].form_ui = :calendar_date_select
    config.columns[:colegiado].clear_link
    config.actions.exclude :show

    # List
    config.list.columns = [:id, :titulo, :colegiado, :fecha_apertura, :fecha_cierre]
    config.list.sorting = {:id => :desc}
    
    # Create
    config.create.link.page = false
    
    # Update
    config.update.label = ""
    config.update.link.page = true

    # New actions
    config.action_links.add 'crear_existente', 
      :action => 'crear_existente', 
      :label => :crear_existente,
      :type => :table, 
      :inline => true,
      :position => :top
    config.action_links.add 'quitar_relacion_expediente', 
      :action => 'quitar_relacion_expediente', 
      :type => :record, 
      :inline => true,
      :position => false,
      :icon => {:image => "actions/expedientes/quitar_relacion.png", :title => "Dejar de relacionar este expediente"},
      :confirm => as_('quitar_relacion_expediente_confirm')
  end if Expediente.table_exists?

  def save_active_scaffold_session
    if params[:embedded] == "expedientes" 
      expediente = Expediente.find(params[:expediente_id])
      active_scaffold_session_storage[:conditions] = ["expedientes.id in (select expediente_relacion_id from expedientes_expedientes where expedientes_expedientes.expediente_id = #{params[:expediente_id]})"]
    end
    active_scaffold_session_storage[:parent_url] ||= params[:parent_url]
  end

  def update_table_config
    if params[:embedded] == "expedientes"
      active_scaffold_config.delete.link.type = false
      active_scaffold_config.search.link.type = false
      active_scaffold_config.action_links.detect{|i| i.label == 'quitar_relacion_expediente'}.type = :record
      active_scaffold_config.action_links.detect{|i| i.label == as_(:crear_existente)}.type = :table
    else
      active_scaffold_config.delete.link.type = :record 
      active_scaffold_config.search.link.type = :table 
      active_scaffold_config.action_links.detect{|i| i.label == 'quitar_relacion_expediente'}.type = false
      active_scaffold_config.action_links.detect{|i| i.label == as_(:crear_existente)}.type = false
    end
  end

  def return_to_main
    redirect_to({'action' => 'edit', 'id' => @record}.merge(active_scaffold_session_storage[:parent_url] || {})) 
  end

  def local_after_create_save(record)
    flash[:notice] = "Expediente creado correctamente"
    if params[:embedded] == 'expedientes'
      # Se asocia el nuevo expediente
      Expediente.transaction do
        expediente = Expediente.find(params[:expediente_id])
        expediente.expedientes << record
        expediente.save
        flash[:notice] += " y asociado al expediente Nº #{expediente.id}" 
        record.expedientes << expediente
        record.save
      end
    end
  end

  def local_after_update_save(record)
    flash[:notice] = "Expediente actualizado correctamente"
  end

  def redirect_after_save(id)
    redirect_to :action => 'edit', :id => id
  end

  # Acciones para los expedientes relacionados.

  def crear_existente
    if request.post?
      if expediente_relacionado = Expediente.find_by_id(params[:expediente_relacionado_id])
        expediente = Expediente.find(params[:expediente_id])
        if not expediente.expedientes_relacionados.include?(expediente_relacionado)
          Expediente.transaction do
            expediente.expedientes << expediente_relacionado 
            expediente.save
            expediente_relacionado.expedientes << expediente
            expediente_relacionado.save
          end
        end
      end
      render :update do |page|
        page << "active_scaffold_update();"
      end
    end
  end

  def quitar_relacion_expediente
    @record = Expediente.find(params[:id])
    expediente = Expediente.find(params[:expediente_id])

    ids = @record.expediente_ids
    ids.delete(expediente.id)
    @record.expediente_ids = ids
    @record.save

    ids = expediente.expediente_ids
    ids.delete(@record.id)
    expediente.expediente_ids = ids
    expediente.save

    render :update do |page|
      page << "active_scaffold_update();"
    end
  end

  def listar_notas
    @record = Expediente.find(params[:id])
  end

  def listar_expedientes
    @record = Expediente.find(params[:id])
  end

end
