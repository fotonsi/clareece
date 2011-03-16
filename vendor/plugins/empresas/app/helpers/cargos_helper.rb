module CargosHelper

  # List columns
  
  def empleados_column(record)
    image_tag("cargos/list/empleados.png", :style => "vertical-align:middle") + " (#{record.empleados.size})"
  end

  
  # Form columns
  
  # Active Scaffold popup
  def popup_title(record)
    title = case params[:action]
    when "new", "create"
      "<u>Nuevo cargo</u>"
    when "edit", "update"
      "Modificar cargo <u>#{record.to_label}</u>"
    when "nested"
      case  params[:associations]
      when "empleados"
        "<b>#{record.to_label}</b> -- <u>Listado de empleados</u>"
      end
    else
      record.to_label
    end
    return title
  end

end
