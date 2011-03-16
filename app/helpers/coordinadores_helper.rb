module CoordinadoresHelper
  def tipo_doc_identidad_form_column(record, input_name)
    select(:record, :tipo_doc_identidad, [['NIF', 'nif'], ['Pasaporte', 'pasaporte'], ['Tarjeta de residencia', 'tarjeta_residencia']], :size => 10)+'&nbsp;'+
      observe_field('record_tipo_doc_identidad', :function => 'cambia_mascara_doc_identidad(value);')
  end

  def doc_identidad_form_column(record, input_name)
      text_field(:record, :doc_identidad, :class => 'text-input', :size => 15, :alt => 'nif')
  end

  def direccion_form_column(record, input_name)
    text_field(:record, :direccion, :class => 'text-input', :size => 30, :maxlength => 255)
  end

  def localidad_id_form_column(record, input_name)
    nice_smart_auto_field(:record, :localidad_id, (record.localidad_id.to_label rescue nil), {:query_url => url_for(:action => 'localidad_autocomplete_results'), :class => 'autocomplete text-input', :size => 50})
  end
end
