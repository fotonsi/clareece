class TransaccionesController < ApplicationController

  include Authentication
  before_filter :access_authorized?
  
  active_scaffold :transaccion do |config|
    # General
    config.label = :label
    config.actions.exclude :delete

    # List
    config.list.columns = [:id, :fecha_cobro, :destinatarios, :concepto, :importe, :importe_total, :forma_pago, :num_movimientos, :fecha_generacion]
    config.list.sorting = {:fecha_cobro => :desc}
    config.columns.add :importe_total, :num_movimientos
    config.columns[:importe_total].css_class = 'numeric'
    config.columns[:num_movimientos].css_class = 'numeric'

    # Create 
    config.create.link.inline = false
    config.create.link.page = true
    config.create.columns.add :tipo
 
    # Update
    config.update.link.page = true

  end if Transaccion.table_exists?

  def listar_movimientos
    @record = Transaccion.find(params[:id])
  end

  def before_create_save(record)
    record.importe = (record.importe || 0).abs
    record.importe = -1*record.importe if params['tipo'] == 'cobro'
  end
 
  # Editamos tras crear.
  def local_after_create_save(record)
    flash[:notice] = "Transacción creada correctamente. #{record.fecha_generacion? ? ('Los movimientos se generarán en el proceso automático del día '+record.fecha_generacion.to_s) : 'Ahora puede generar los movimientos.'}"
  end

  def redirect_after_save(id)
    redirect_to :action => 'edit', :id => id
  end

  def generar
    @record = Transaccion.find(params[:id])
    begin
      @record.generar! if self.successful?
    rescue
      self.successful = false
    end
    #render :partial => 'refresh_form', :locals => {
      #:success_message => "Remesa GENERADA correctamente. Compruebe los recibos antes de ENTREGAR la remesa."
    #}
    redirect_to :action => 'list'
  end
end
