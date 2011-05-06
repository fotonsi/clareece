module ColegiosHelper

  # Form columns
  def entidad_form_column(record, input_name)
    text_field(:record, :entidad, :size => 4, :maxlength => 4, :class => 'entidad-input text-input')+'-'+
      text_field(:record, :oficina, :size => 4, :maxlength => 4, :class => 'entidad-input text-input')+'-'+
      text_field(:record, :dc, :size => 2, :maxlength => 2, :class => 'entidad-input text-input')+'-'+
      text_field(:record, :cuenta, :size => 20, :maxlength => 20, :class => 'entidad-input text-input')
  end

  def localidad_id_form_column(record, input_name)
    loc = Localidad.find(record.localidad_id).to_label rescue nil
    nice_smart_auto_field(:record, :localidad_id, loc, {:search_fields => [:cp, :nombre], :model => Localidad, :class => 'autocomplete text-input', :size => 60, :tip => 'especifique términos de búsqueda'})
  end
end
