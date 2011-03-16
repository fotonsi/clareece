class FacturaDetallesController < ApplicationController
  active_scaffold :factura_detalle do |config|
    config.list.columns = [:cantidad, :precio, :total, :cliente, :concepto] #:impuesto, 
    config.create.columns = [:cantidad, :precio, :cliente_id, :concepto_id]#:impuesto, 
    config.update.columns = [:cantidad, :precio, :cliente_id, :concepto_id] #:impuesto, 
  
  end

  def before_create_save(record)
    if params[:record][:cliente_id]
      record.cliente_type = params[:record][:cliente_id][:tipo]
      record.cliente_id= params[:record][:cliente_id][:id]
    end
#    record.total = record.precio * record.cantidad
  end

  def before_update_save(record)
    before_create_save(record)
  end

end
