module ColegiadosWebHelper
  def num_colegiado_column(record)
    record.num_colegiado
  end

  def nombre_column(record)
    "#{record.nombre} #{record.apellido1} #{record.apellido2}"
  end

  def especialidades_column(record)
    record.colegiado_especialidades.map {|ce| ce.especialidad.nombre if ce.especialidad}.compact.join("\n")
  end

  #Search
  def num_colegiado_search_column(record, input_name)
    hidden_field_tag('search[num_colegiado][opt]', '=')+text_field_tag('search[num_colegiado][from]', nil, :size => 8, :maxlength => 6, :class => 'text-input')
  end

  def nombre_search_column(record, input_name)
    text_field :search, :nombre, :size => 20, :maxlength => 20, :class => 'text-input'
  end

  def apellido1_search_column(record, input_name)
    text_field :search, :apellido1, :size => 20, :maxlength => 20, :class => 'text-input'
  end

  def apellido2_search_column(record, input_name)
    text_field :search, :apellido2, :size => 20, :maxlength => 20, :class => 'text-input'
  end
end
