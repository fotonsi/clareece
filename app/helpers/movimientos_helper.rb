module MovimientosHelper

  def list_information_content
    defaults = params[:defaults] || {}
    if titular_id = (controller.active_scaffold_constraints[:titular_id] || defaults[:titular_id])
      klass = (controller.active_scaffold_constraints[:titular_type] || defaults[:titular_type]).constantize
      titular = klass.find(titular_id)
      render :partial => "list_information_content", :locals => {:titular => titular}
    end
  end

  def list_row_class(record)
    record.anulado? ? "mov-anulado" : ""
  end

  def forma_pago_label(forma_pago)
    forma_pago = 'empty' if forma_pago.blank?
    I18n.t "view.movimiento.forma_pago.#{forma_pago}"
  end


  # List columns
  
  def importe_column(record)
    %|<label style='#{'color: red; ' if record.importe < 0}'>#{'+' if record.importe > 0}#{ExportUtils.value2text(record.importe)}</label>|
  end

  def saldo_final_column(record)
    %|<label style='#{'color: red; ' if record.saldo_final < 0}'>#{'+' if record.saldo_final > 0}#{ExportUtils.value2text(record.saldo_final)}</label>|
  end

  def concepto_de_column(record)
    h(record.concepto_de.humanize) if record.concepto_de
  end

  def concepto_column(record)
    lbl = h(record.concepto)
    lbl = "<span style='color:red'><small>(rec. devuelto&nbsp;#{record.fecha_devolucion.strftime("%d/%m/%Y") if record.fecha_devolucion})</small>&nbsp;</span>"+lbl if record.fecha_devolucion
    lbl
  end

  def forma_pago_column(record)
    forma_pago_label(record.forma_pago)
  end

  def titular_column(record)
    if titular = record.titular
      if titular.kind_of?(Colegiado)
        link_to titular.to_label, 
                {:controller => 'colegiados', :action => 'listar_movimientos', :id => titular},
               :title => 'Ir a movimientos del colegiado' 
      elsif titular.kind_of?(Colegio)
        "#{record.a_favor_de}"
      end
    else 
      '-'
    end
  end

  def render_importe_sum(value)
    value ? ExportUtils::value2text(value) : 0
  end


  # Search columns

  def titular_search_column(record, input_name)
    text_field :record, :titular, :name => input_name, :class => 'text-input'
  end

  def fecha_search_column(record, input_name)
    calendar_date_select(:record, :fecha, :class => 'text-input', :name => input_name + "[from]", :time => 'mixed') + "&nbsp;-&nbsp;"+
    calendar_date_select(:record, :fecha, :class => 'text-input', :name => input_name + "[to]", :time => 'mixed')
  end

  def concepto_de_search_column(record, input_name)
    concepto_de_form_column record, input_name
  end

  def concepto_search_column(record, input_name)
    concepto_form_column record, input_name
  end

  def forma_pago_search_column(record, input_name)
    select :record, :forma_pago, Movimiento::FORMAS_PAGO.map{|i| [forma_pago_label(i), i.to_s]}.unshift(['-- Seleccionar --', nil]), {}, :name => input_name, :class => 'text-input'
  end

  def importe_search_column(record, input_name)
    column = active_scaffold_config.field_search.columns.select{|c| c.name == :importe}
    active_scaffold_search_float column, :name => 'search[importe]', :class => 'text-input'
  end

  def estado_search_column(record, input_name)
    select_tag input_name, options_for_select([["-- Seleccionar --", nil], ["Anulados", 'anulado'], ["Activos", 'activo']]), :param_name => input_name, :class => "text-input"
  end

  def tipo_search_column(record, input_name)
    select_tag input_name, options_for_select([["-- Seleccionar --", nil], ['Pago', 'pago'], ['Cobro', 'cobro']]), :param_name => input_name, :class => "text-input"
  end


  # Form columns
  
  def colegiado_id_form_column(record, input_name)
    col = Colegiado.find(record.colegiado_id).to_label rescue nil
    nice_smart_auto_field(:record, :colegiado_id, col, {:search_fields => [:num_colegiado, :nombre, :apellido1, :apellido2, :doc_identidad], :model => Colegiado, :class => 'autocomplete text-input', :size => 50, :tip => 'especifique términos de búsqueda'})
  end

  def fecha_form_column(record, input_name)
    calendar_date_select :record, :fecha, :class => "text-input fecha-input datetime-input #{'readonly-input' if !record.new_record? && record.forma_pago == 'efectivo'}", :alt => 'fechahora', :value => (@record.fecha || Time.now).strftime("%d-%m-%Y %H:%M"), :default_time => (@record.fecha || Time.now)
  end

  def concepto_de_form_column(record, input_name)
    select :record, :concepto_de, 
      Movimiento::Concepto::TIPOS.map{|i| [Movimiento::Concepto.label(i), i.to_s]}.unshift(['-- Seleccionar --', nil]), {}, 
      :name => input_name, :class => 'text-input'
  end

  def concepto_form_column(record, input_name)
    text_field :record, :concepto, :name => input_name, :class => 'text-input'
  end

  def forma_pago_form_column(record, input_name)
    select :record, :forma_pago, Movimiento::FORMAS_PAGO.map{|i| [forma_pago_label(i), i.to_s]}.unshift(['-- Seleccionar --', nil]), {}, :name => input_name, :class => 'text-input', 
      :onclick => %|var fecha = $('record_fecha');
                    if (this.value == 'efectivo') {
                      jQuery(setFieldMode(fecha, 'readonly'));
                      var f = new Date();
                      f = f.getDate()+'-'+(f.getMonth()+1)+'-'+f.getFullYear()+' '+f.getHours()+':'+f.getMinutes();
                      fecha.value = f;
                    } else {
                      jQuery(setFieldMode(fecha, 'enabled'))
                    }|
  end

  def importe_form_column(record, input_name)
    text_field :record, :importe, :name => input_name, :class => 'text-input', :size => 5, :onchange => %|
      if(parseInt($('record_importe').value) < 0){
        $('record_forma_pago').value = 'efectivo';
        setFieldMode('record_forma_pago', 'disabled');
      }
      else
        setFieldMode('record_forma_pago', 'enabled');
    |, :alt => 'decimal'
  end

  def a_favor_de_form_column(record, input_name)
    text_field :record, :a_favor_de, :name => input_name, :class => 'text-input'
  end

  def tipo_form_column(record, input_name)
    select_tag :tipo, options_for_select([['Pago/Devengo', 'pago'], ['Cobro', 'cobro']], (record.importe && record.importe < 0 ? 'cobro' : 'pago')), :onclick => "if (this.value == 'cobro') {$('a_favor_de_lbl').innerHTML = 'Recibido de'} else {$('a_favor_de_lbl').innerHTML = 'A favor de'}"
  end
end
