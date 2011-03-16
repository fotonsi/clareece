module InformesHelper
  # Columnas de listado
  def filename_column(record)
    if record.filename
      link_to(record.filename, 
              {:controller => 'informes', :action => 'download', :id => record.id},
              :title => record.filename)
    else
      "-"
    end
  end

  def registro_column(record)
    record.registro? ? 'Sí' : 'No'
  end

  # Columnas de formulario
  def objeto_form_column(record, input_name)
    select :record, :objeto, Informe::MODELOS.map {|m| [m.to_s.titleize, m.to_s]}
  end

  def uploaded_data_form_column(record, input_name)
    file_field :record, :uploaded_data
  end
end
