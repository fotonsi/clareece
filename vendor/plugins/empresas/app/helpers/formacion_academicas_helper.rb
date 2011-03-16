module FormacionAcademicasHelper
  # Form columns
  [
    ["titulacion", {}],
    ["fecha", {}]
  ].each {|campo|
      options = campo.last.kind_of?(Hash) ? campo.last.inspect : campo.last
      class_eval <<-EOC
        def #{campo.first}_form_column(record, input_name)
            inline_group(record).field :#{campo.first}, {:param_name => input_name, :css_class => 'text-input'}.merge(#{options})
        end 
      EOC
  }

  # Active Scaffold popup
  def popup_title(record)
    case params[:action]
    when "new", "create"
      "Nueva formación específica"
    when "edit", "update"
      "Modificar formación específica"
    when "nested"
      case  params[:associations]
      when "formacion_especificas"
        "Formación específica de <b>#{record.empleado}</b>"
      end
    else
      record ? record.to_label : "-"
    end
  end

end
