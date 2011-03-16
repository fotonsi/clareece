module PaisesHelper
  def provincias_column(record)
    "#{record.provincias.size} provs."
  end
 
  # Active Scaffold popup
  def popup_title(record)
    case params[:action]
    when "nested"
      case  params[:associations]
      when "provincias"
        "<b>#{record.nombre}</b> -- <u>Listado de provincias</u>"
      end
    end
  end

end
