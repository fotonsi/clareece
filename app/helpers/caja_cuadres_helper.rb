module CajaCuadresHelper
  #List columns
  def ingresos_column(record)
    ExportUtils.value2text(record.ingresos)
  end

  def pagos_column(record)
    ExportUtils.value2text(record.pagos)
  end

  def saldo_caja_column(record)
    %|<label style='#{'color: red; ' if record.saldo_caja < 0}'>#{'+' if record.saldo_caja > 0}#{ExportUtils.value2text(record.saldo_caja)}</label>|
  end

  def total_detalle_column(record)
    ExportUtils.value2text(record.total_detalle)
  end

  def saldo_column(record)
    %|<label style='#{'color: red; ' if record.saldo < 0}'>#{'+' if record.saldo > 0}#{ExportUtils.value2text(record.saldo)}</label>|
  end

  def cerrado_column(record)
    I18n.t("forms.bool.#{record.cerrado || false}")
  end

  #Form columns
  %w(cent_1 cent_2 cent_5 cent_10 cent_20 cent_50 eur_1 eur_2 eur_5 eur_10 eur_20 eur_50 eur_100 eur_200 eur_500).each do |column|
    class_eval <<-EOC
      def #{column}_form_column(record, input_name)
        text_field :record, :#{column}, :name => input_name, :class => 'text-input', :size => 4, :onchange => "actualizar_total_efectivo()", :alt => 'integer'
      end
    EOC
  end

  def fecha_form_column(record, input_name)
    calendar_date_select :record, :fecha, :class => "text-input datetime-input #{'readonly-input' if !record.new_record?}", :alt => 'fechahora', :value => (@record.fecha || Time.now).strftime("%d-%m-%Y %H:%M"), :default_time => (@record.fecha || Time.now)
  end

  def saldo_anterior_form_column(record, input_name)
    text_field_tag 'record[saldo_anterior]', record.saldo_cuadre_anterior, :id => 'record_saldo_anterior', :class => 'text-input', :size => 10, :onchange => "actualizar_total_ingresos()", :alt => 'signed-decimal', :readonly => true
  end

  def ingresos_form_column(record, input_name)
    text_field_tag('record[ingresos]', sprintf('%.2f', record.ingresos_desde_cuadre_anterior), :id => 'record_ingresos', :class => 'text-input', :size => 10, :onchange => "actualizar_total_ingresos()", :alt => 'decimal', :readonly => true)+"(#{record.movs_ingresos_desde_cuadre_anterior.size} movs.) "+link_to(image_tag('/images/shared/informe.gif', :alt => 'Listar movimientos de ingresos', :title => 'Listar movimientos de ingresos', :style => 'vertical-align: middle;'), :action => 'listar_ingresos', :id => @record.id, :fecha => (Time.now if @record.new_record?))
  end

  def pagos_form_column(record, input_name)
    text_field_tag('record[pagos]', sprintf('%.2f', record.pagos_desde_cuadre_anterior), :id => 'record_pagos', :class => 'text-input', :size => 10, :onchange => "actualizar_total_pagos()", :alt => 'decimal', :readonly => true)+"(#{record.movs_pagos_desde_cuadre_anterior.size} movs.) "+link_to(image_tag('/images/shared/informe.gif', :alt => 'Listar movimientos de pagos', :title => 'Listar movimientos de pagos', :style => 'vertical-align: middle;'), :action => 'listar_pagos', :id => @record.id, :fecha => (Time.now if @record.new_record?))
  end

  def ingresado_bancos_form_column(record, input_name)
    text_field :record, :ingresado_bancos, :name => input_name, :class => 'text-input', :size => 10, :onchange => "actualizar_total_pagos()", :alt => 'decimal'
  end

  def ingresado_datafono_form_column(record, input_name)
    text_field :record, :ingresado_datafono, :name => input_name, :class => 'text-input', :size => 10, :onchange => "actualizar_total_pagos()", :alt => 'decimal'
  end

  def cheques_form_column(record, input_name)
    text_field :record, :cheques, :name => input_name, :class => 'text-input', :size => 10, :onchange => "actualizar_total_detalle()", :alt => 'decimal'
  end

  def vales_form_column(record, input_name)
    text_field :record, :vales, :name => input_name, :class => 'text-input', :size => 10, :onchange => "actualizar_total_detalle()", :alt => 'decimal'
  end

  def total_detalle_form_column(record, input_name)
    text_field_tag 'record[total_detalle]', sprintf('%.2f', (record.total_detalle || 0)), :id => 'record_total_detalle', :class => 'text-input', :size => 10, :alt => 'decimal', :readonly => true
  end

  def saldo_form_column(record, input_name)
    val = ((record.saldo_cuadre_anterior + record.ingresos_desde_cuadre_anterior - (record.pagos_desde_cuadre_anterior + (record.ingresado_bancos || 0) + (record.ingresado_datafono || 0))) - (record.total_detalle || 0))
    text_field_tag 'record[saldo]', sprintf('%.2f', val), :id => 'record_saldo', :class => 'text-input', :size => 10, :alt => 'signed-decimal', :readonly => true
  end

  def efectivo_form_column(record, input_name)
    text_field_tag 'record[efectivo]', sprintf('%.2f', (record.efectivo || 0)), :id => 'record_efectivo', :class => 'text-input', :size => 10, :alt => 'decimal', :readonly => true
  end

  def saldo_caja_form_column(record, input_name)
    val = (record.saldo_cuadre_anterior + record.ingresos_desde_cuadre_anterior - (record.pagos_desde_cuadre_anterior + (record.ingresado_bancos || 0) + (record.ingresado_datafono || 0)))
    text_field_tag 'record[saldo_caja]', sprintf('%.2f', val), :id => 'record_saldo_caja', :class => 'text-input', :size => 10, :alt => 'signed-decimal', :readonly => true
  end

  def saldo_caja2_form_column(record, input_name)
    val = (record.saldo_cuadre_anterior + record.ingresos_desde_cuadre_anterior - (record.pagos_desde_cuadre_anterior + (record.ingresado_bancos || 0) + (record.ingresado_datafono || 0)))
    text_field_tag 'record_saldo_caja2', sprintf('%.2f', val), :class => 'text-input', :size => 10, :alt => 'decimal', :readonly => true
  end

  def suma_ingresos_form_column(record, input_name)
    val = (record.saldo_cuadre_anterior + record.ingresos_desde_cuadre_anterior)
    text_field_tag 'record[suma_ingresos]', sprintf('%.2f', val), :id => 'record_suma_ingresos', :class => 'text-input', :size => 10, :alt => 'decimal', :readonly => true
  end

  def suma_pagos_form_column(record, input_name)
    val = (record.pagos_desde_cuadre_anterior + (record.ingresado_bancos || 0) + (record.ingresado_datafono || 0))
    text_field_tag 'record[suma_pagos]', sprintf('%.2f', val), :id => 'record_suma_pagos', :class => 'text-input', :size => 10, :alt => 'decimal', :readonly => true
  end

  def cerrado_form_column(record, input_name)
    select(:record, :cerrado, [[I18n.t("forms.bool.false"), false], [I18n.t("forms.bool.true"), true]], {}, :name => input_name)
  end
end
