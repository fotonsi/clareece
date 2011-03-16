class RemesasController < ApplicationController
  include Authentication
  before_filter :access_authorized?

  active_scaffold :remesa do |config|

    # General
    config.label = :label
    config.columns[:importe_total].label = "Total €"
    config.actions.exclude :show

    # List
    config.columns.add :fichero
    config.columns[:fichero].label = "Fichero bancario"
    config.columns[:fichero].css_class = "centrado"
    config.list.columns = [:id, :fecha_cobro, :tipo, :concepto, :estado, :fecha_generacion, :importe_total, :num_movimientos, :fichero]
    config.list.sorting = {:fecha_cobro => :desc}
    config.columns.add :importe_total, :num_movimientos
    config.columns[:importe_total].calculate = :sum
    config.columns[:importe_total].css_class = 'numeric'
    config.columns[:num_movimientos].css_class = 'numeric'
    
    # Search
    config.actions.add :field_search
    config.field_search.columns = [:tipo, :created_at, :concepto_de, :concepto, :estado, :importe]

    # Create
    config.create.label = "" 
    config.create.link.action = 'new_general'
    config.create.link.label = :new_general
    config.create.link.page = true

    # Update
    config.update.label = ""
    config.update.link.page = true

    # New actions
    config.action_links.add 'new_individual', 
      :action => 'new_individual', 
      :label => :new_individual,
      :type => :table, 
      :page => true,
      :order => 2

    config.action_links.add 'new_individual_saldar_deuda', 
      :action => 'new_individual_saldar_deuda', 
      :label => :new_individual_saldar_deuda,
      :type => :table, 
      :page => true,
      :order => 3

  end if Remesa.table_exists?

  include FieldSearch

  def self.condition_for_created_at_column(column, value, like_pattern)
    condition_for_datetime_type(column, value, like_pattern)
  end


  # Redirección y mensajes tras crear o editar.
  def return_to_main
    info = "Remesa <<#{@record.to_label}>> GUARDADA correctamente"
    flash[:notice] = info
    redirect_to :action => 'edit', :id => @record
  end

  def new_general
    active_scaffold_session_storage[:defaults] ||= {}
    active_scaffold_session_storage[:defaults][:tipo] = :general.to_s
    new
  end

  def new_individual
    active_scaffold_session_storage[:defaults] ||= {}
    active_scaffold_session_storage[:defaults][:tipo] = :individual.to_s
    new
  end

  def new_individual_saldar_deuda
    if request.post?
      begin
        r = Remesa.generar_individual_saldar_deuda(params[:record][:fecha_cobro], params[:record][:concepto_de], params[:record][:concepto], params[:record][:importe])
      rescue Exception => e
        flash[:error] = "Error al generar la remesa (#{e.message})"
        redirect_to :action => 'list'
      	return
      end
      if r.valid?
        redirect_to :action => 'edit', :id => r.id
      else
        @record = r
        render :action => 'create'
        return
      end
    end
  end

  def generar
    @record = Remesa.find(params[:id])
    begin
      @record.generar! if self.successful?
    rescue
      self.successful = false
    end
    #render :partial => 'refresh_form', :locals => {
      #:success_message => "Remesa GENERADA correctamente. Compruebe los recibos antes de ENTREGAR la remesa."
    #}
    redirect_to :action => 'edit', :id => @record.id
  end

  def entregar
    @record = Remesa.find(params[:id])
    begin
      @record.entregar! if self.successful?
    rescue
      self.successful = false
    end
    #render :partial => 'refresh_form', :locals => {
    #  :success_message => "Remesa ENTREGADA correctamente"
    #}
    redirect_to :action => 'edit', :id => @record.id
  end

  def anular 
    @record = Remesa.find(params[:id])
    begin
      @record.anular!
      self.successful = true
    rescue
      self.successful = false
    end
    redirect_to :action => 'edit', :id => @record.id
  end

  def borrar_recibos
    @record = Remesa.find(params[:id])
    begin
      @record.borrar_recibos!
      self.successful = true
    rescue
      self.successful = false
    end
    redirect_to :action => 'edit', :id => @record.id
  end

  def programar_entrega
    @record = Remesa.find(params[:id])
    @record.fecha_entrega = Date.today + 1.day
    if @record.save
      flash[:info] = "Entrega de la remesa <<#{@record.to_label}>> programada correctamente para mañana"
    else
      flash[:error] = I18n.t("application.action_error")
    end
    redirect_to :action => 'list'
  end

  def programar_anulacion
    @record = Remesa.find(params[:id])
    @record.fecha_anulacion = Date.today + 1.day
    if @record.save
      flash[:info] = "Anulación de la remesa <<#{@record.to_label}>> programada correctamente para mañana"
    else
      flash[:error] = I18n.t("application.action_error")
    end
    redirect_to :action => 'list'
  end

  def fichero_bancario
    @record = Remesa.find(params[:id])
    if @record.generar_fichero_bancario
      flash[:info] = "Fichero bancario generado, lo puede descargar mediante el enlace disponible."
    else
      flash[:error] = I18n.t("application.action_error")
    end
    redirect_to :action => 'list'
  end
 
  def listar_recibos
    @record = Remesa.find(params[:id])
  end

  def download
    documento = Documento.find(params[:id])
    send_file documento.full_filename, :type => documento.content_type, :file_name => documento.filename
  end

end
