module ColegiosHelper

  # Form columns
  def entidad_form_column(record, input_name)
    text_field(:record, :entidad, :size => 4, :maxlength => 4, :class => 'entidad-input text-input')+'-'+
      text_field(:record, :oficina, :size => 4, :maxlength => 4, :class => 'entidad-input text-input')+'-'+
      text_field(:record, :dc, :size => 2, :maxlength => 2, :class => 'entidad-input text-input')+'-'+
      text_field(:record, :cuenta, :size => 20, :maxlength => 20, :class => 'entidad-input text-input')
  end

  def localidad_id_form_column(record, input_name)
    nice_smart_auto_field(:record, :localidad_id, (record.localidad_id.to_label rescue nil), {:query_url => url_for(:action => 'localidad_autocomplete_results'), :class => 'autocomplete text-input', :size => 50})
  end
end
