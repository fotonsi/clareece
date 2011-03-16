module ProvinciasHelper

  def localidades_column(record)
    "#{record.localidades.size} locs."
  end
 
  # Active Scaffold popup
  def popup_title(record)
    case params[:action]
    when "nested"
      case  params[:associations]
      when "localidades"
        "<b>#{record.pais.nombre}</b> -- <b>#{record.nombre}</b> -- <u>Listado de localidades</u>"
      end
    end
  end

end
