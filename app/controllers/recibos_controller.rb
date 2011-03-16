class RecibosController < ApplicationController
  include Authentication
  before_filter :access_authorized?
  active_scaffold :recibo do |config|
    # General
    config.actions.exclude :show

    # List
    config.list.columns = [:id, :titular, :concepto, :importe_total, :estado]
    config.columns[:importe_total].calculate = :sum
    
    # Search
    config.actions.add :field_search
    config.columns[:titular].search_sql = "" # Necesita que no sea nil para que se llame al método condition_for_titular_column
    config.field_search.columns = [:titular, :created_at, :concepto_de, :concepto, :estado, :importe]

   # Create
    config.create.columns.add :colegiado_id 
    config.create.label = ""

    # Update
    config.update.columns.add :colegiado_id
    config.update.label = ""
    config.update.link.position = :after

    # New actions
    config.action_links.add 'listar_movimientos', 
      :action => 'listar_movimientos', 
      :label => :listar_movimientos,
      :icon => {:image => "shared/movimientos.png", :title => 'Movimientos creados'},
      :type => :record, 
      :inline => true,
      :position => :after

  end if Recibo.table_exists?

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

  def self.condition_for_created_at_column(column, value, like_pattern)
    condition_for_datetime_type(column, value, like_pattern)
  end

  def generar
    do_update
    begin
      @record.generar! if self.successful?
    rescue
      self.successful = false
    end
    render :partial => 'refresh_form', :locals => {
      :success_message => "Recibo GENERADO correctamente. Puede comprobar los movimientos generados."
    }
  end

  def anular 
    @record = Recibo.find(params[:id])
    begin
      @record.anular!
      self.successful = true
    rescue
      self.successful = false
    end
    render :partial => 'refresh_form', :locals => {
      :success_message => "Recibo ANULADO correctamente. Puede comprobar los movimientos de anulación generados."
    }
  end

  def devolver 
    @record = Recibo.find(params[:id])
    begin
      @record.devolver!
      self.successful = true
    rescue
      self.successful = false
    end
    render :partial => 'refresh_form', :locals => {
      :success_message => "Recibo DEVUELTO correctamente. Puede comprobar los movimientos de anulación generados."
    }
  end

  def listar_movimientos
    @record = Recibo.find(params[:id])
  end

  # Authorized

  def create_authorized?
    remesa = Remesa.find(active_scaffold_session_storage[:constraints][:remesa_id])
    not remesa.anulado?
  end

end
