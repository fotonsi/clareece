module RemesasHelper

  def tipo_label(tipo)
    I18n.t("view.remesa.tipo.#{tipo}")
  end

  def estado_label(estado)
    I18n.t("view.remesa.estado.#{estado}")
  end

  def concepto_de_label(concepto)
    I18n.t "view.movimiento.concepto.#{concepto}"
  end

  def recibos_list_id(record)
    "remesa#{record.id}-recibos_list"
  end


  # Layout

  def layout_title(record)
    out = "#{image_tag('layout/locator/arrow1.png', :style => "vertical-align: top;")} "
    text = case params[:action]
    when 'new', 'create', 'new_general', 'new_individual'
      "Alta de nueva remesa"
    when 'edit', 'update'
      "Datos de remesa"
    else
      record.to_label
    end
    out + text
  end

  def layout_actions(record)
    actions = []
    if not record.new_record?
      actions << {:label => t('layout_action.editar_remesa'), :image => "shared/remesas.png", :url => {:action => 'edit', :id => @record, :mode => params[:mode]}}
      actions <<  {:label => t('layout_action.listar_recibos'), :image => "shared/recibos.png", :url => {:action => 'listar_recibos', :id => @record, :mode => params[:mode]}} if record.general?
    end
    render_layout_actions actions 
  end


  # List columns

  def tipo_column(record)
    record.tipo.blank? ? '-' : tipo_label(record.tipo)
  end

  def estado_column(record)
    estado = record.estado.blank? ? '-' : estado_label(record.estado)
    if record.entrega_programada?
      estado << " (entrega programada)"
    elsif record.anulacion_programada?
      estado << " (anulación programada)"
    end
    return estado
  end

  def concepto_column(record)
    record.tipo == 'general' ? %|(#{Movimiento::Concepto.label(record.concepto_de)}) #{record.concepto}| : 'Varios'
  end

  def importe_total_column(record)
    ExportUtils::value2text(record.importe_final)
  end

  def fichero_column(record)
    if record.fichero_bancario
      link_to("descargar", 
              {:controller => 'remesas', :action => 'download', :id => record.fichero_bancario},
              :title => record.fichero_bancario.filename)
    else
      "-"
    end
  end

  # Search columns

  def tipo_search_column(record, input_name)
    select :record, :tipo, Remesa::TIPOS.map{|i| [tipo_label(i), i.to_s]}, {:include_blank => true},
      :name => input_name, :class => 'text-input'
  end

  def created_at_search_column(record, input_name)
    calendar_date_select(:record, :created_at, :class => 'text-input', :name => input_name + "[from]", :time => false) + "&nbsp;-&nbsp;"+
    calendar_date_select(:record, :created_at, :class => 'text-input', :name => input_name + "[to]", :time => false)
  end

  def concepto_de_search_column(record, input_name)
    concepto_de_form_column record, input_name
  end

  def concepto_search_column(record, input_name)
    concepto_form_column record, input_name
  end

  def estado_search_column(record, input_name)
    select :remesa, :estado, Remesa::ESTADOS.map{|i| [estado_label(i), i.to_s]}, {:include_blank => true},
      :name => input_name, :class => 'text-input'
  end

  def importe_search_column(record, input_name)
    column = active_scaffold_config.field_search.columns.select{|c| c.name == :importe}
    active_scaffold_search_float column, :name => 'search[importe]', :class => 'text-input'
  end


  # Form columns

  def fecha_cobro_form_column(record, input_name)
    calendar_date_select :record, :fecha_cobro, :class => 'text-input date-input', :name => input_name, :alt => 'fecha', :size => 8
  end

  def fecha_generacion_form_column(record, input_name)
    calendar_date_select :record, :fecha_generacion, :class => 'text-input', :name => input_name, :alt => 'fecha', :size => 8
  end

  def fecha_entrega_form_column(record, input_name)
    calendar_date_select :record, :fecha_entrega, :class => 'text-input', :name => input_name, :alt => 'fecha', :size => 8
  end

  def fecha_anulacion_form_column(record, input_name)
    calendar_date_select :record, :fecha_anulacion, :class => 'text-input', :name => input_name, :alt => 'fecha', :size => 8
  end

  def importe_total_form_column(record, input_name)
    text_field :record, :importe_total, :name => input_name, :class => 'text-input readonly-input', :size => 5, :readonly => true, :alt => 'signed-decimal'
  end

  %w(concepto_de concepto_de1 concepto_de2 concepto_de3 concepto_de4 concepto_de5).each do |column|
    class_eval <<-EOC
      def #{column}_form_column(record, input_name)
        select :record, :#{column}, Movimiento::Concepto::TIPOS.map{|i| [Movimiento::Concepto.label(i), i.to_s]}, {:include_blank => true},
          :name => input_name, :class => 'text-input'
      end
    EOC
  end

  %w(importe importe1 importe2 importe3 importe4 importe5).each do |column|
    class_eval <<-EOC
      def #{column}_form_column(record, input_name)
        text_field :record, :#{column}, :name => input_name, :class => 'text-input', :size => 5, :onchange => "actualizar_importe_total()", :alt => 'signed-decimal'
      end
    EOC
  end

  %w(concepto concepto1 concepto2 concepto3 concepto4 concepto5).each do |column|
    class_eval <<-EOC
      def #{column}_form_column(record, input_name)
        text_field :record, :#{column}, :name => input_name, :class => 'text-input', :size => 35
      end
    EOC
  end
end
