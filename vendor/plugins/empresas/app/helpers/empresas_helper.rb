module EmpresasHelper

  # List columns
  def sedes_column(record)
    image_tag("empresas/list/sedes.png", :style => "vertical-align:middle") + " (#{record.sedes.size})"
  end

  def localidad_id_column(record)
    %|<div style="text-align: left;">
      #{record.localidad ? record.localidad.to_label : "-" }
    </div>
    |
  end

  # Form columns
  #TODO Quitar remix (esto no se usa en la apli?)
  [
    ["nombre", {}],
    ["cif", {}],
    ["direccion", {}],
    ["localidad_id", {:class => LocalidadSelector}],
    ["telefono1", {}],
    ["telefono2", {}],
    ["fax", {}]
  ].each {|campo|
      options = campo.last.kind_of?(Hash) ? campo.last.inspect : campo.last
      class_eval <<-EOC
        def #{campo.first}_form_column(record, input_name)
            remix_group(:record).field :#{campo.first}, {:param_name => input_name, :css_class => 'text-input'}.merge(#{options})
        end 
      EOC
  }


  # Active Scaffold popup
  def popup_title(record)
    case params[:action]
    when "nested"
      case  params[:associations]
      when "sedes"
        "<b>#{record.nombre}</b> -- <u>Listado de sedes</u>"
      end
    else
      record ? record.to_label : "-"
    end
  end

end
