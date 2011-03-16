module TransaccionesHelper

  def destinatarios_label(destinatarios)
    I18n.t "view.transaccion.destinatarios.#{destinatarios}"
  end

  def forma_pago_label(forma_pago)
    forma_pago = 'empty' if forma_pago.blank?
    I18n.t "view.movimiento.forma_pago.#{forma_pago}"
  end

  # Layout

  def layout_actions(record)
    actions = []
    if not record.new_record?
      actions += [
        {:label => t('layout_action.transacciones'), :image => "actions/transacciones/transaccion.png", :title => 'Transacciones', :url => {:action => 'show', :id => @record}},
        {:label => t('layout_action.movimientos'), :image => "actions/transacciones/movimientos.png", :title => 'Movimientos', :url => {:action => 'listar_movimientos', :id => @record}},
      ]
    end
    render_layout_actions actions 
  end


  # List columns
  
  def destinatarios_column(record)
    record.destinatarios.blank? ? '-' : destinatarios_label(record.destinatarios)
  end

  def concepto_column(record)
    %|(#{Movimiento::Concepto.label(record.concepto_de)}) #{record.concepto}|
  end

  def importe_column(record)
    if record.importe < 0
      %|<label style='color: red;'>#{record.importe}</label>|
    else
      %|+#{record.importe}|
    end
  end

  def importe_total_column(record)
    val = record.importe_final
    if val < 0
      %|<label style='color: red;'>#{ExportUtils::value2text(val)}</label>|
    else
      %|+#{ExportUtils::value2text(val)}|
    end
  end

  def num_movimientos_column(record)
    record.movimientos.count
  end

  # Form columns

  def concepto_de_form_column(record, input_name)
    select :record, :concepto_de, 
      Movimiento::Concepto::TIPOS.map{|i| [Movimiento::Concepto.label(i), i.to_s]}.unshift(['-- Seleccionar --', nil]), {},
      :name => input_name, :class => 'text-input'
  end
 
  def concepto_form_column(record, input_name)
    text_field :record, :concepto, :name => input_name, :class => 'text-input'
  end

  def importe_form_column(record, input_name)
    text_field :record, :importe, :name => input_name, :class => 'text-input', :size => 5
  end

  def destinatarios_form_column(record, input_name)
    select :record, :destinatarios, Transaccion::DESTINATARIOS.map{|i| [destinatarios_label(i), i.to_s]}.unshift(['-- Seleccionar --', nil]),
      {}, :name => input_name, :class => 'text-input'
  end

  def fecha_cobro_form_column(record, input_name)
    calendar_date_select :record, :fecha_cobro, :class => 'text-input fecha_cobro-input date-input', :alt => 'fecha', :size => 8
  end

  def fecha_generacion_form_column(record, input_name)
    calendar_date_select :record, :fecha_generacion, :class => 'text-input fecha_generacion-input date-input', :alt => 'fecha', :size => 8
  end

  def tipo_form_column(record, input_name)
    select_tag :tipo, options_for_select([['Pago/Devengo', 'pago'], ['Cobro', 'cobro']])
  end

  def forma_pago_form_column(record, input_name)
    select :record, :forma_pago, Movimiento::FORMAS_PAGO.map{|i| [forma_pago_label(i), i.to_s]}.unshift(['-- Seleccionar --', nil]), {}, :name => input_name, :class => 'text-input'
  end
end
