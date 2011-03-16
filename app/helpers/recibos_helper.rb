module RecibosHelper

  def form_column_id(record, column, options = {})
    options[:controller] ||= params[:controller]
    options[:action] ||= params[:action]
    "#{options[:controller]}-#{options[:action]}-record#{record.id}_#{column}"
  end

  def estado_label(estado)
    I18n.t("view.recibo.estado.#{estado}")
  end


  # List columns

  def titular_column(record)
    link_to(record.titular.to_label, {:controller => 'colegiados', :action => 'listar_movimientos', :id => record.titular.id}) if record.titular
  end

  def estado_column(record)
    record.estado.blank? ? '-' : estado_label(record.estado)
  end

  def concepto_column(record)
    %|(#{Movimiento::Concepto.label(record.concepto_de)}) #{record.concepto}|
  end


  # Search columns

  def titular_search_column(record, input_name)
    text_field :record, :titular, :name => input_name, :class => 'text-input'
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
    select :recibos, :estado, Recibo::ESTADOS.map{|i| [estado_label(i), i.to_s]}, {:include_blank => true},
      :name => input_name, :class => 'text-input'
  end

  def importe_search_column(record, input_name)
    column = active_scaffold_config.field_search.columns.select{|c| c.name == :importe}
    active_scaffold_search_float column, :name => 'search[importe]', :class => 'text-input'
  end



  # Form columns

  def colegiado_id_form_column(record, input_name)
    nice_smart_auto_field(:record, :colegiado_id, (record.colegiado.to_label rescue nil), {:query_url => url_for(:action => 'colegiado_autocomplete_results'), :class => 'autocomplete text-input', :size => 50})
  end

  def importe_total_form_column(record, input_name)
    text_field :record, :importe_total, :name => input_name, :id => form_column_id(record, :importe_total),
      :class => 'text-input readonly-input', :size => 5, :readonly => true, :alt => 'signed-decimal'
  end

  %w(concepto_de concepto_de1 concepto_de2 concepto_de3 concepto_de4 concepto_de5).each do |column|
    class_eval <<-EOC
      def #{column}_form_column(record, input_name)
        select :record, :#{column}, Movimiento::Concepto::TIPOS.map{|i| [Movimiento::Concepto.label(i), i.to_s]}, {:include_blank => true},
          :id => form_column_id(record, :#{column}), :name => input_name, :class => 'text-input'
      end
    EOC
  end

  %w(importe importe1 importe2 importe3 importe4 importe5).each do |column|
    class_eval <<-EOC
      def #{column}_form_column(record, input_name)
        text_field :record, :#{column}, :name => input_name, :id => form_column_id(record, :#{column}),  
          :class => 'text-input', :size => 5, :onchange => "actualizar_importe_total_recibo"+record.id.to_s+"()", :alt => 'signed-decimal' 
      end
    EOC
  end

  %w(concepto concepto1 concepto2 concepto3 concepto4 concepto5).each do |column|
    class_eval <<-EOC
      def #{column}_form_column(record, input_name)
        text_field :record, :#{column}, :name => input_name, :id => form_column_id(record, :#{column}), 
          :class => 'text-input', :size => 35 
      end
    EOC
  end

end
