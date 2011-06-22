module GestionesDocumentalesHelper

  def label_tipo(record)
    record.tipo.blank? ? "" : I18n.t("view.gestion_documental.tipo.#{record.tipo}")
  end

  
  # List columns

  def tipo_column(record)
    record.tipo.blank? ? '-' : label_tipo(record) 
  end

  def texto_column(record)
    if record.documento && File.exists?(record.documento.full_filename)
      link_to((record.texto || '&lt;sin descripci&oacute;n&gt;'),
              {:controller => 'gestiones_documentales', :action => 'download', :id => record.documento}, 
              :title => 'Descargar documento adjunto')
    else
      (record.texto || '')+' (no existe fichero)' || '&lt;sin descripci&oacute;&gt;'
    end
  end

  def etiquetas_column(record)
    record.documento.tag_list.join(" ") if record.documento
  end

  def num_registro_column(record)
    "reg. de #{record.tipo} nº #{record.num_registro}"
  end

  def expedientes_column(record)
    record.expedientes.map {|e| str = e.to_label; "#{str[0..39]}#{'...' if str.size > 40}"}
  end


  # Form columns
  
  def tipo_form_column(record, input_name)
    tipos_for_select = GestionDocumental::TIPOS.map{|i| [I18n.t("view.gestion_documental.tipo.#{i}"), i.to_s]}
    select_tag('record_tipo_sel', options_for_select(tipos_for_select, record.tipo)) +
    hidden_field_tag('record[tipo]', (record.tipo || tipos_for_select[0][1]), :id => 'record_tipo_gd') +
    observe_field('record_tipo_sel', :function => %|
          if ($('record_tipo_sel').value == 'entrada') {
              $('direccion_destinatario_tr').toggle();
              $('direccion_remitente_tr').toggle();
              $('record_remitente').value = ''
              $('record_destinatario').value = '#{TIPO_OBJETO.capitalize}'
          } else {
              $('direccion_destinatario_tr').toggle();
              $('direccion_remitente_tr').toggle();
              $('record_remitente').value = '#{TIPO_OBJETO.capitalize}'
              $('record_destinatario').value = ''
          }
          $('record_tipo_gd').value = $('record_tipo_sel').value;
      |
    )
  end

  def responsable_form_column(record, input_name)
    text_field_tag "record[responsable]", (record.responsable || (controller.current_user.nombre if controller.current_user)), :class => 'text-input', :size => '20'
  end

  def remitente_form_column(record, input_name)
    text_field_tag("record[remitente]", record.remitente, :id => 'record_remitente', :class => 'text-input', :size => '40')
  end

  def direccion_remitente_form_column(record, input_name)
    text_area_tag("record[direccion_remitente]", record.direccion_remitente, :class => 'text-input', :size => '60x2')
  end

  def destinatario_form_column(record, input_name)
    text_field_tag("record[destinatario]", (record.destinatario || TIPO_OBJETO.capitalize), :id => 'record_destinatario', :class => 'text-input', :size => '40')
  end

  def direccion_destinatario_form_column(record, input_name)
    text_area_tag("record[direccion_destinatario]", record.direccion_destinatario, :class => 'text-input', :size => '60x2')
  end

  def uploaded_data_form_column(record, input_name)
    str = file_field(:record, :uploaded_data, :class => 'text-input')
    str += 'Doc. actual: '+link_to(record.documento.filename, {:action => 'download', :id => record.documento}, :title => record.documento.filename) if record.documento
    str
  end

  def documento_id_form_column(record, input_name)
    hidden_field(:record, :documento_id) if record.documento
  end

  def observaciones_form_column(record, input_name)
    text_area :record, :observaciones, :cols => 40, :rows => 3
  end

  def texto_form_column(record, input_name)
    text_area :record, :texto, :cols => 40, :rows => 3
  end

  def etiquetas_form_column(record, input_name)
    exp_id = params[:expediente_id].to_i if params[:expediente_id]
    text_area_tag('etiquetas', (record.documento.tag_list.join(" ") if record.documento), :class => 'text-input', :size => '100x2')+
      %|<span id="indicator1" style="display: none;">
          <img src="/#{APP_PREFIX}images/active_scaffold/default/indicator.gif" alt="Consultando..." style="vertical-align: middle;" />
        </span>
        <div class="autocomplete" id='auto_complete_etiquetas'></div>|+       
          javascript_tag(%|new Ajax.Autocompleter('etiquetas', 'auto_complete_etiquetas',
                      "#{url_for(:action => 'etiquetas_auto_complete', :expediente_id => exp_id)}", {method: 'get', paramName: 'val', minChars: 1, indicator: 'indicator1', tokens: ' '})|)
  end

  #search
  def created_at_search_column(record, input_name)
    calendar_date_select(:record, :created_at, :class => 'text-input created_at-input date-input', :name => input_name+"[from]")+"&nbsp;-&nbsp;"+calendar_date_select(:record, :created_at, :class => 'text-input created_at-input date-input', :name => input_name+"[to]")
  end

  def tipo_search_column(record, input_name)
    select(:record, :tipo, [[I18n.t("forms.bool.undef"), nil], ['entrada', 'entrada'], ['salida', 'salida']], {}, :name => input_name)
  end

  def destinatario_search_column(record, input_name)
    text_field_tag("record[destinatario]", nil, :name => input_name, :class => 'text-input', :size => '40')
  end

  def remitente_search_column(record, input_name)
    text_field_tag("record[remitente]", nil, :name => input_name, :class => 'text-input', :size => '40')
  end

  def texto_search_column(record, input_name)
    text_field_tag("record[texto]", nil, :name => input_name, :class => 'text-input', :size => '40')
  end

  def observaciones_search_column(record, input_name)
    text_field_tag("record[observaciones]", nil, :name => input_name, :class => 'text-input', :size => '40')
  end

end
