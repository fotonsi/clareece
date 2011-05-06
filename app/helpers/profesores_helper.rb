module ProfesoresHelper
  def tipo_doc_identidad_form_column(record, input_name)
    select(:record, :tipo_doc_identidad, [['NIF', 'nif'], ['Pasaporte', 'pasaporte'], ['Tarjeta de residencia', 'tarjeta_residencia']], :size => 10)+'&nbsp;'+
      observe_field('record_tipo_doc_identidad', :function => 'cambia_mascara_doc_identidad(value);')
  end

  def doc_identidad_form_column(record, input_name)
      text_field(:record, :doc_identidad, :class => 'text-input', :size => 15, :alt => 'nif')
  end

  def localidad_id_form_column(record, input_name)
    loc = Localidad.find(record.localidad_id).to_label rescue nil
    nice_smart_auto_field(:record, :localidad_id, loc, {:search_fields => [:cp, :nombre], :model => Localidad, :class => 'autocomplete text-input', :size => 60, :tip => 'especifique términos de búsqueda'})
  end
end
