class PreciosController < ApplicationController
  active_scaffold :precio do |config|
    #config.columns.add [:concepto, :cliente]
    config.list.columns = [:concepto, :cliente, :precio, :impuesto]
    config.create.columns = [:concepto_id, :cliente_id, :precio, :impuesto_id]
    config.update.columns = [:concepto_id, :cliente_id, :precio, :impuesto_id]
    config.list.label = "Facturación: Precios"
    config.create.label = "Nuevo precio"
    config.columns[:cliente].label = "Aplicable a"
    config.columns[:precio].label = "Precio (€)"
  end

  def before_create_save(record)
    #if params[:record][:origen_id]
    #  record.origen_type = params[:record][:origen_id][:tipo]
    #  record.origen_id = params[:record][:origen_id][:id]
    #end
    #if params[:record][:cliente_id]
    #  record.cliente_type = params[:record][:cliente_id][:tipo]
    #  record.cliente_id= params[:record][:cliente_id][:id]
    #end
  end

  def before_update_save(record)
    before_create_save(record)
  end
end
