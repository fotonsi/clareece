class MovimientosController < ApplicationController
  include Authentication
  before_filter :access_authorized?

  # Embedded: colegiados | transacciones | formaciones | cursos

  before_filter :update_table_config

  @@list_columns = [:id, :fecha, :titular, :concepto_de, :concepto, :forma_pago, :importe, :saldo_final]
  active_scaffold :movimiento do |config|
    # General
    config.label = "movimientos.label" 
    config.actions.exclude :delete, :show

    # List
    config.list.columns = @@list_columns 
    config.list.sorting = [{:fecha => :desc}, {:id => :desc}]
    config.columns.add :saldo_final
    config.columns[:saldo_final].css_class = 'numeric'
    config.columns[:importe].calculate = :sum

    # Search
    config.actions.add :field_search
    config.columns[:titular].search_sql = "" # Necesita que no sea nil para que se llame al método condition_for_titular_column
    config.columns.add :estado
    config.columns[:estado].search_sql = "" 
    config.columns.add :tipo
    config.columns[:tipo].search_sql = "" 
    config.field_search.columns = [:titular, :fecha, :concepto_de, :concepto, :forma_pago, :importe, :estado, :tipo]

    # Create
    config.create.link.inline = true
    config.create.columns.add :colegiado_id, :tipo

    # Update
    config.update.link.inline = true
    config.update.columns.add :colegiado_id, :tipo

    # New actions

    config.action_links.add 'anular', 
      :action => 'anular', 
      :type => :record, 
      :inline => true,
      :position => false,
      :icon => {:image => "actions/movimientos/cross.png", :title => "Des/Anular movimiento"},
      :confirm => as_('anular_confirm')

    config.action_links.add 'devolucion', 
      :action => 'devolucion', 
      :type => :record, 
      :inline => false,
      :position => false,
      :icon => {:image => "actions/movimientos/devolver.png", :title => "Efectuar devolución del movimiento"},
      :confirm => as_('devolver_confirm')

    config.action_links.add 'recibo_devuelto', 
      :action => 'recibo_devuelto', 
      :type => :record, 
      :inline => true,
      :position => false,
      :icon => {:image => "shared/exento_pagos.png", :title => "Marcar recibo devuelto por banco"},
      :confirm => as_('recibo_devuelto_confirm')

    config.action_links.add 'libramiento',
      :action => 'libramiento',
      :type => :record,
      :inline => true,
      :position => false,
      :icon => {:image => "actions/movimientos/libramiento.png", :title => "Libramiento"}
  
    config.action_links.add 'recibo_cuota',
      :action => 'recibo_cuota',
      :type => :record,
      :inline => true,
      :position => false,
      :icon => {:image => "actions/movimientos/recibo_cuota.png", :title => "Recibo"}
  
  end if Movimiento.table_exists?

  def anular
    @record = Movimiento.find(params[:id])
    if @record.anulado?
      @record.update_attribute(:fecha_anulacion, nil)
    else
      @record.update_attribute(:fecha_anulacion, Time.now)
    end
    render :action => "update_list", :layout => false
  end

  def devolucion
    @record = Movimiento.find(params[:id])
    begin
      @record.devolucion
      flash[:notice] = 'Se creó movimiento de devengo y de pago para la devolución, por favor, revíselos.'
    rescue Exception => e
      flash[:error] = e.message
    end
    redirect_to :action => 'list'
  end

  def recibo_devuelto
    @record = Movimiento.find(params[:id])
    if @record.devuelto?
      @record.update_attribute(:fecha_devolucion, nil)
    else
      @record.update_attribute(:fecha_devolucion, Time.now)
    end
    render :action => "update_list", :layout => false
  end

  def libramiento
    redirect_to :controller => 'informes', :action => 'parsea', :id => Informe.find_by_objeto('libramiento'), :objeto_id => params[:id], :sin_registro => true
  end

  def recibo_cuota
    mov = Movimiento.find(params[:id])
    nombre_informe = mov.concepto_de == 'cuota_colegiacion' ? 'recibo_cuota' : 'recibo_generico'
    redirect_to :controller => 'informes', :action => 'parsea', :id => Informe.find_by_objeto(nombre_informe), :objeto_id => params[:id], :sin_registro => true
  end

  # Search

  include FieldSearch
  
  def self.condition_for_titular_column(column, value, like_pattern)
    if value =~ /^#\d+$/
      conds = conditions_for_text(value[1..-1], %w(num_colegiado))
      ids = ActiveRecord::Base.connection.select_all("select id from colegiados where num_colegiado = #{value[1..-1]}").map{|i| i['id'].to_i}
    else
      conds = conditions_for_text(value, %w(nombre apellido1 apellido2 doc_identidad))
      ids = ActiveRecord::Base.connection.select_all("select id from colegiados where #{conds}").map{|i| i['id'].to_i}
    end
    ["titular_type = ? and titular_id in (?)", 'Colegiado', ids]
  end

  def self.condition_for_fecha_column(column, value, like_pattern)
    condition_for_datetime_type(column, value, like_pattern)
  end

  def self.condition_for_estado_column(column, value, like_pattern)
    case value
    when 'anulado'
      ["fecha_anulacion is not null"]
    when 'activo'
      ["fecha_anulacion is null"]
    end
  end

  def self.condition_for_tipo_column(column, value, like_pattern)
    case value
    when 'pago'
      ["importe > 0"]
    when 'cobro'
      ["importe < 0"]
    end
  end

  def before_create_save(record)
    record.titular = Colegio.first if params['titular_colegio']
    record.titular = record.origen.alumno if params[:nested] && params[:parent_model] == 'Formacion'
    record.importe = (record.importe || 0).abs
    record.importe = -1*record.importe if params['tipo'] == 'cobro'
    record.fecha = Time.now if record.forma_pago == 'efectivo' && record.new_record?
  end

  def before_update_save(record)
    before_create_save(record)
  end

  protected

  def update_table_config
    # CREATE. Desde [transacciones, recibos] no podemos crear nuevos movimientos.
    if %w(transacciones recibos).include? params[:embedded]
      active_scaffold_config.create.link.type = false
    else
      active_scaffold_config.create.link.type = :table 
    end

    # SEARCH. Desde [recibos] no podemos realizar búsquedas.
    if %w(recibos).include? params[:embedded]
      active_scaffold_config.search.link.type = false
    else
      active_scaffold_config.search.link.type = :table 
    end
   
    # COLUMNS. Desde colegiados mostramos el saldo final.
    if params[:embedded] == "colegiados"
      active_scaffold_config.list.columns.exclude @@list_columns
      active_scaffold_config.list.columns.add @@list_columns 
    else
      active_scaffold_config.list.columns.exclude @@list_columns
      active_scaffold_config.list.columns.add(@@list_columns-[:saldo_final])
    end
  end

  # Authorized

  def libramiento_authorized?(record)
    record.authorized_for_libramiento?
  end

  def recibo_cuota_authorized?(record)
    record.authorized_for_recibo_cuota?
  end

  def devolucion_authorized?(record)
    record.authorized_for_devolucion?
  end

end
