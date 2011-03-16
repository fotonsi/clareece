module SedesHelper

  # List columns
  def empleados_column(record)
    image_tag("sedes/list/empleados.png", :style => "vertical-align:middle") + " (#{record.empleados.size})"
  end

  def localidad_id_column(record)
    %|<div style="text-align: left;">
      #{record.localidad ? record.localidad.to_label : "-" }
    </div>
    |
  end

  # Form columns 
  [
    ["nombre", {}],
    ["apellido1", {}],
    ["apellido2", {}],
    ["localidad_id", {:class => LocalidadSelector}],
    ["direccion", {}],
    ["telefono1", {}],
    ["telefono2", {}],
    ["fax", {}]
  ].each {|campo|
      options = campo.last.kind_of?(Hash) ? campo.last.inspect : campo.last
      class_eval <<-EOC
        def #{campo.first}_form_column(record, input_name)
            inline_group(record).field :#{campo.first}, {:param_name => input_name, :css_class => 'text-input'}.merge(#{options})
        end 
      EOC
  }

  def empresa_form_column(record, input_name)
    inline_group(record).field :empresa_id, :class => ActiveScaffoldSelectBox, :options => Empresa.options_for_select,
      :param_name => input_name, :css_class => 'text-input'
  end

  # Active Scaffold popup
  def popup_title(record)
    if constraints = controller.active_scaffold_session_storage[:constraints]
      empresa = Empresa.find(constraints[:empresa] || constraints[:empresa_id])
    else
      empresa = record.empresa
    end

    title = case params[:action]
    when "new", "create"
      "<u>Nueva sede</u>"
    when "edit", "update"
      "<b>#{record.to_label}</b>"
    when "nested"
      case  params[:associations]
      when "empleados"
        "<b>#{record.to_label}</b> -- <u>Listado de empleados</u>"
      end
    else
      record ? record.to_label : "-"
    end
    title = "<b>#{empresa.to_label}</b> -- " + title if empresa
    return title
  end

end
