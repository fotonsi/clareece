class ConceptosController < ApplicationController
  active_scaffold :concepto do |config|
    config.list.columns = [:codigo, :descripcion]
    config.create.columns = [:codigo, :descripcion]
    config.update.columns = [:codigo, :descripcion]
    config.list.label = "Facturación: Conceptos"
    config.create.label = "Nuevo concepto"
    config.columns[:codigo].label = "Código"
    config.columns[:descripcion].label = "Descripción"
  end

  def before_create_save(record)
    if params[:record][:objeto_id]
      record.objeto_type = params[:record][:objeto_id][:tipo]
      record.objeto_id = params[:record][:objeto_id][:id]
    end
  end
  
  def before_update_save(record)
    before_create_save(record)
  end
end
