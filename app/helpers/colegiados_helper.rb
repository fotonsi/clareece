module ColegiadosHelper

  def situacion_colegial_label(sc)
    I18n.t "view.#{OBJETO_PRINCIPAL}.situacion_colegial.#{sc}" if !sc.blank?
  end

  def forma_pago_label(forma_pago)
    forma_pago = 'empty' if forma_pago.blank?
    I18n.t "view.movimiento.forma_pago.#{forma_pago}"
  end

  # Layout

  def layout_actions(record)
    actions = []
    if not record.new_record?
      actions << {:label => t("layout_action.#{OBJETO_PRINCIPAL}s"), :image => "actions/colegiados/datos.png", :url => {:action => 'edit', :id => @record, :mode => params[:mode]}}
      actions << {:label => t('layout_action.cursos'), :image => "actions/colegiados/cursos.png", :url => {:action => 'listar_cursos', :id => @record, :mode => params[:mode]}} if TIPO_OBJETO == 'colegio'
      actions << {:label => t('layout_action.movimientos'), :image => "actions/colegiados/movimientos.png", :url => {:action => 'listar_movimientos', :id => @record, :mode => params[:mode]}}
      actions << {:label => t('layout_action.informes'), :image => "shared/informe.gif", :url => {:action => 'listar_informes', :id => @record, :mode => params[:mode]}}
    end
    render_layout_actions actions 
  end

  def layout_title(record)
    if record.new_record? || record.num_colegiado == 0
      num_provis = ActiveRecord::Base.connection.select_one('select last_value from num_colegiado_seq')["last_value"].to_i + 1
      "Alta de nuevo #{OBJETO_PRINCIPAL} (nº #{OBJETO_PRINCIPAL} provisional #{num_provis})"
    else
      record.to_label+(record.expediente ? " (exp. #{link_to(record.expediente.id, {:controller => 'expedientes', :action => 'edit', :id => @record.expediente}, :title => "Acceder al expediente del #{OBJETO_PRINCIPAL}")})" : ' (sin exp.)')
    end
  end

  # List columns

  def situacion_colegial_column(record)
    situacion_colegial_label record.situacion_colegial
  end

  def num_colegiado_column(record)
    %|<span style="color: red;">#{'B' if record.situacion_colegial == 'baja_colegial'}</span>&nbsp;#{record.num_colegiado}|
  end

  def apellidos_column(record)
    link_to record.apellidos, url_for(:action => 'edit', :id => record.id)
  end

  def nombre_column(record)
    link_to record.nombre, url_for(:action => 'edit', :id => record.id)
  end

  # Form columns

  def situacion_colegial_form_column(record, input_name)
    select(:record, :situacion_colegial, [[I18n.t("forms.bool.undef"), nil]]+Colegiado::SITUACIONES_COLEGIALES.map{|i| [situacion_colegial_label(i), i.to_s]}, {}, :name => input_name, :onchange =>  "cambia_situacion_colegial();")+
      hidden_field_tag('record_situacion_colegial_orig', record.situacion_colegial)
  end

  def exento_pago_form_column(record, input_name)
    calendar_date_select(:record, :fecha_ini_exencion_pago, :class => 'text-input fecha_ini_exencion_pago date-input', :alt => 'fecha')+" - "+
    calendar_date_select(:record, :fecha_fin_exencion_pago, :class => 'text-input fecha_fin_exencion_pago date-input', :alt => 'fecha')
  end

  def sociedad_profesional_form_column(record, input_name)
    select :record, :sociedad_profesional, [['No', false], ['Sí', true]]
  end

  def banco_id_form_column(record, input_name)
    nice_select(input_name, Banco, record.banco_id, :options => Banco.find(:all, :order => 'nombre').map {|b| ["#{b.nombre} (#{b.cod_entidad})", b.id.to_s]})+observe_field('record_banco_id', :function => %|var c = jQuery("input[name='record[num_cuenta]']")[0];
                              var b = $('record_banco_id');
                              var txt = b.options[b.selectedIndex].text;
                              var val = txt.replace(/.*\\((.*)\\)/, '$1');
                              c.value = "000".slice(val.length - 1)+val;
                              c.focus();
                              c.selectionStart = c.selectionEnd;|)
  end

  def pais_id_form_column(record, input_name)
    nice_select(input_name, Pais, record.pais_id)+text_field(:record, :localidad_nacimiento, :size => 30, :maxlength => 30, :class => 'text-input localidad_nacimiento-input')
  end

  def localidad_nacimiento_form_column(record, input_name)
    #Lo dejamos vacío para que lo use pero lo mostramos junto al pais
  end

  def tipo_doc_identidad_form_column(record, input_name)
    select(:record, :tipo_doc_identidad, [['NIF', 'nif'], ['Pasaporte', 'pasaporte'], ['Tarjeta de residencia', 'tarjeta_residencia']], :size => 10)+'&nbsp;'+
      text_field(:record, :doc_identidad, :class => 'text-input', :size => 15, :alt => (record.tipo_doc_identidad|| 'nif'))+
      observe_field('record_tipo_doc_identidad', :function => 'cambia_mascara_doc_identidad(value);')
  end

  def doc_identidad_form_column(record, input_name)
    #Lo dejamos vacío porque ya va con el tipo_doc_identidad pero queremos que AS lo coja
  end

  def motivo_ingreso_id_form_column(record, input_name)
    nice_select input_name, TipoProcedencia, record.motivo_ingreso_id, :options => TipoProcedencia.find(:all, :order => 'descripcion').map {|tp| [tp.descripcion, tp.id.to_s]}
  end

  def procedencia_form_column(record, input_name)
    select(:record, :procedencia, [[I18n.t("forms.bool.undef"), nil]]+Provincia.find(:all, :order => 'nombre').map {|p| [p.nombre, p.nombre]})
  end

  def motivo_baja_id_form_column(record, input_name)
    nice_select input_name, TipoDestino, record.motivo_baja_id, :options => TipoDestino.find(:all, :order => 'descripcion').map {|td| [td.descripcion, td.id.to_s]}
  end

  def destino_form_column(record, input_name)
    select(:record, :destino, [[I18n.t("forms.bool.undef"), nil]]+Provincia.find(:all, :order => 'nombre').map {|p| [p.nombre, p.nombre]})
  end

  def centro_id_form_column(record, input_name)
    nice_select input_name, Centro, record.centro_id
  end

  def fecha_nacimiento_form_column(record, input_name)
    calendar_date_select :record, :fecha_nacimiento, :class => 'text-input fecha_nacimiento-input date-input', :alt => 'fecha'
  end

  def fecha_ingreso_form_column(record, input_name)
    calendar_date_select :record, :fecha_ingreso, :class => 'text-input fecha_ingreso-input date-input', :alt => 'fecha'
  end

  def fecha_baja_form_column(record, input_name)
    calendar_date_select :record, :fecha_baja, :class => 'text-input fecha_baja-input date-input', :alt => 'fecha'
  end

  def pais_residencia_id_form_column(record, input_name)
    nice_select(input_name, Pais, record.pais_residencia_id)+text_field(:record, :localidad, :size => 30, :maxlength => 30, :class => 'text-input localidad-input')+text_field(:record, :cod_postal, :style => 'width: 4em;', :class => 'cod_postal-input text-input')
  end

  def localidad_form_column(record, input_name)
    #Lo dejamos vacío para que lo use pero lo mostramos junto al pais
  end

  def cod_postal_form_column(record, input_name)
    #Lo dejamos vacío para que lo use pero lo mostramos junto al pais
  end

  # Subform widgets
  def profesion_form_column(record, input_name)
    nice_select input_name, Profesion, record.profesion_id
  end

  def especialidad_form_column(record, input_name)
    nice_select input_name, Especialidad, record.especialidad_id
  end

  def titular_cuenta_form_column(record, input_name)
    select(:record, :titular_cuenta, [['Sí', true], ['No', false]], :size => 4)+'&nbsp;'+
      observe_field('record_titular_cuenta', :function => %|
                                                            if ($('record_titular_cuenta').value == 'true') {
                                                                jQuery("#record_titular_cuenta").parent().parent().parent().next().hide();
                                                            } else {
                                                                jQuery("#record_titular_cuenta").parent().parent().parent().next().show();
                                                            }|)
  end

  def cuota_ingreso_forma_pago_form_column(record, input_name)
    select(:record, :cuota_ingreso_forma_pago, Movimiento::FORMAS_PAGO.map{|i| [forma_pago_label(i), i.to_s]}.sort.unshift(['-- Seleccionar --', nil]), {}, :name => input_name, :class => 'text-input')
  end

  def sexo_form_column(record, input_name)
    select(:record, :sexo, [[I18n.t("forms.bool.undef"), nil], ['Hombre', 'H'], ['Mujer', 'M']])
  end

  def grado_carrera_form_column(record, input_name)
    select(:record, :grado_carrera, [[I18n.t("forms.bool.undef"), nil]]+Colegiado::GRADOS_CARRERA.sort.map {|k,v| [v,k]})
  end

  def situacion_profesional_form_column(record, input_name)
    select(:record, :situacion_profesional, [[I18n.t("forms.bool.undef"), nil]]+Colegiado::SITUACIONES_PROFESIONALES.sort.map {|k,v| [v,k]})
  end

  def ejercicio_profesional_form_column(record, input_name)
    select(:record, :ejercicio_profesional, [[I18n.t("forms.bool.undef"), nil]]+Colegiado::EJERCICIOS_PROFESIONALES.sort.map {|k,v| [v,k]})
  end

  def direccion_form_column(record, input_name)
    text_field :record, :direccion, :name => input_name, :class => 'direccion-input text-input', :size => 30, :maxlength => 255
  end

  #Search fields
  def num_colegiado_search_column(record, input_name)
    text_field_tag("search_num_colegiado_from", nil, :class => 'text-input', :name => "#{input_name}[from]", :size => 10)+content_tag('span', ' - '+text_field_tag("search_num_colegiado_to", nil, :class => 'text-input', :name => "#{input_name}[to]", :size => 10), :id => "search_num_colegiado_between", :style => "display:none")+'&nbsp;'+select_tag("#{input_name}[opt]", options_for_select(ActiveScaffold::Finder::NumericComparators.collect {|comp| [as_(comp.downcase.to_sym), comp]}), :onchange => "Element[this.value == 'BETWEEN' ? 'show' : 'hide']('search_num_colegiado_between');")
  end

  def fecha_ingreso_search_column(record, input_name)
    calendar_date_select(:record, :fecha_ingreso, :class => 'text-input fecha_ingreso-input date-input', :name => input_name+"[from]", :alt => 'fecha')+"&nbsp;-&nbsp;"+calendar_date_select(:record, :fecha_ingreso, :class => 'text-input fecha_ingreso-input date-input', :name => input_name+"[to]", :alt => 'fecha')
  end

  def fecha_baja_search_column(record, input_name)
    calendar_date_select(:record, :fecha_baja, :class => 'text-input fecha_baja-input date-input', :name => input_name+"[from]", :alt => 'fecha')+"&nbsp;-&nbsp;"+calendar_date_select(:record, :fecha_baja, :class => 'text-input fecha_baja-input date-input', :name => input_name+"[to]", :alt => 'fecha')
  end

  def doc_identidad_search_column(record, input_name)
    text_field :record, :doc_identidad, :name => input_name, :class => 'doc_identidad-input text-input'
  end

  def situacion_colegial_search_column(record, input_name)
    select(:record, :situacion_colegial, [[I18n.t("forms.bool.undef"), nil]]+Colegiado::SITUACIONES_COLEGIALES.map{|i| [situacion_colegial_label(i), i.to_s]}, {}, :name => input_name)
  end

end
