module FormacionesHelper
  
  def label_estado(record)
    if record.kind_of?(Formacion)
      record.estado.blank? ? '-' : I18n.t("view.formacion.estado.#{record.estado}")
    else
      record.blank? ? '-' : I18n.t("view.formacion.estado.#{record.to_s}")
    end
  end

  def forma_pago_label(forma_pago)
    I18n.t "view.movimiento.forma_pago.#{forma_pago}"
  end

  def actions_estado(record)
    out = label_estado(record) + " "
    case record.estado
    when 'matriculado'
      out += link_to("Dar de baja", {:action => 'baja_curso', :id => record}, :confirm => as_(:are_you_sure))
    when 'baja'
      out += link_to("Matricular", {:action => 'matricular', :id => record}, :confirm => as_(:are_you_sure))
    end
    return out
  end

  # Layout

  def layout_actions(record)
    actions = []
    if not record.new_record?
      actions += [
        {:label => t('layout_action.formacion'), :title => "Formación. Ficha de matrícula del alumno", :image => "actions/formaciones/curso.png", :url => {:action => 'edit', :id => @record}},
        {:label => t('layout_action.asistencias'), :image => "actions/formaciones/asistencia.png", :title => 'Asistencia', :url => {:action => 'asistencia', :formacion_id => @record}},
      ]
    end
    render_layout_actions actions 
  end

  # List columns

  def alumno_column(record)
    link_to(record.alumno.to_label, {:controller => record.alumno_type.pluralize, :action => 'edit', :id => record.alumno}) if record.alumno
  end
  
  def asistencia_column(record)
    h(record.curso.asistencia_de(record.alumno))+"%"
  end

  def estado_column(record)
    label_estado record
  end

  def movimientos_column(record)
    "#{record.movimientos.size} movs. (saldo #{record.movimientos.inject(0) {|suma, m| suma+(m.fecha_anulacion.nil? ? m.importe : 0)}})"
  end

  def forma_pago_column(record)
    dev = record.movimientos.find(:first, :conditions => ['importe < 0'])
    forma_pago_label((dev ? dev.forma_pago : record.forma_pago))
  end

  def apto_column(record)
    I18n.t("forms.bool.#{record.apto || false}")
  end
  
  # Form columns

  def curso_id_form_column(record, input_name)
    cursos_actuales = record.alumno.formaciones.map {|f| f.curso_id}
    cursos_actuales = [0] if cursos_actuales.empty?
    select :record, :curso_id, Curso.find(:all, :conditions => ["id not in (?)", cursos_actuales]).map {|c| [c.nombre, c.id]}
  end

  def colegiado_id_form_column(record, input_name)
    col = Colegiado.find(record.colegiado_id).to_label rescue nil
    nice_smart_auto_field(:record, :colegiado_id, col, {:search_fields => [:num_colegiado, :nombre, :apellido1, :apellido2, :doc_identidad], :model => Colegiado, :class => 'autocomplete text-input', :size => 50, :tip => 'especifique términos de búsqueda'})
  end

  def estado_form_column(record, input_name)
    label_estado(record) + hidden_field(:record, :estado)
  end

  def forma_pago_form_column(record, input_name)
    select :record, :forma_pago, Movimiento::FORMAS_PAGO.map{|i| [forma_pago_label(i), i.to_s]}
  end

  # Search columns

  def alumno_search_column(record, input_name)
    text_field :record, :alumno, :name => input_name, :class => 'text-input'
  end

  def created_at_search_column(record, input_name)
    calendar_date_select(:record, :created_at, :class => 'text-input', :name => input_name + "[from]", :time => false) + "&nbsp;-&nbsp;"+
    calendar_date_select(:record, :created_at, :class => 'text-input', :name => input_name + "[to]", :time => false)
  end

  def forma_pago_search_column(record, input_name)
    select :record, :forma_pago, Formacion::FORMAS_PAGO.map{|i| [forma_pago_label(i), i.to_s]}.unshift(['-- Seleccionar --', nil]), {}, :name => input_name, :class => 'text-input'
  end

  def estado_search_column(record, input_name)
    select_tag input_name, options_for_select([["-- Seleccionar --",  nil]]+Formacion::ESTADOS.map {|e| [label_estado(e), e]}), :param_name => input_name, :class => "text-input"
  end
end
