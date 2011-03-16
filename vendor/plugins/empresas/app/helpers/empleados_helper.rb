module EmpleadosHelper

  # List columns

  def cargo_id_column(record)
    record.cargo ? record.cargo.to_label : "-"
  end

  def telefonos_column(record)
    record.telefonos.join('<br />')
  end

  def sede_id_column(record)
    sede = record.sede
    sede ? "#{sede.empresa.to_label} - #{sede.to_label}" : "-"
  end

  def en_nomina_column(record)
    if record.en_nomina?
      "Sí"
    else
      fecha = (record.fecha_baja && record.fecha_baja.strftime) || as_(:dont_say)
      %|<label title="Baja #{fecha}">No</label>|
    end
  end


  # Form columns
  def sede_form_column(record, input_name)
    inline_group(record).field :sede_id, :class => ActiveScaffoldSelectBox, 
      :options => Sede.options_for_select(:label => "label_for_select"),
      :param_name => input_name, :css_class => 'text-input'
  end

  def cargo_form_column(record, input_name)
    inline_group(record).field :cargo_id, :class => ActiveScaffoldSelectBox, 
      :options => Cargo.options_for_select, :param_name => input_name, :css_class => 'text-input'
  end


  # Search columns

  # Active Scaffold Popup
  def popup_title(record)
    if constraints = controller.active_scaffold_session_storage[:constraints]
      if constraints[:sede]
        sede = Sede.find(constraints[:sede])
      elsif constraints[:cargo]
        cargo = Cargo.find(constraints[:cargo])
      end
    end
    return "" if not record

    title = case params[:action]
    when "new", "create"
      "<u>Nuevo empleado</u>"
    else
      "<u>#{record.to_label}</u> #{"YA NO ESTÁ EN NÓMINA" if not record.en_nomina?}"
    end

    origen = ""
    origen = "<b>#{sede.empresa.nombre}</b> -- <b>#{sede.to_label}</b> -- " if sede
    origen = "<b>#{cargo.to_label}</b> -- " if cargo
    return(origen + title)
  end

end
