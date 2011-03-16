module CursosHelper

  def form_actions(record)
    return if record.new_record?
    out = [] 
    out << link_to('Email', {:action => 'notificar_curso', :id => record}, 
                   :confirm => "¿Enviar email de notificación de celebración del curso?") if record.sin_iniciar?

    if record.finalizado?
      diplomas = options_for_select([['-- seleccione plantilla --', nil]]+Informe.find_all_by_objeto('diploma').map {|td| [td.nombre, td.id]})
      out << select_tag(:tipo_diploma, diplomas)+' '+
      link_to_remote('Generar diplomas', :url => {:controller => 'formaciones', :action => 'genera_diplomas', :curso_id => record.id}, :with => '"diploma_id=" + $("tipo_diploma").value', :class => 'boton')
    end
    out << link_to('Acta', {:action => 'acta_curso', :id => record},
                   :confirm => "¿Realizar el acta del curso?") if record.finalizado?
    out << link_to('Cancelar', {:action => 'cancelar_curso', :id => record},
                   :confirm => "¿Cancelar el curso? No se podrá volver a activar") if record.sin_iniciar?
    return out.join(' | ')
  end

  def estado_label(estado)
    I18n.t("view.curso.estado.#{estado}")
  end

  # Layout

  def layout_actions(record)
    actions = []
    if not record.new_record?
      actions += [
        { 
          :label => t('layout_action.cursos').singularize, 
          :image => "actions/cursos/datos.png", 
          :url => {:action => 'edit', :id => @record}
        },
        {
          :label => t('layout_action.alumnos'), 
          :image => "actions/cursos/alumnos.png", 
          :url => {:action => 'listar_alumnos', :id => @record}
        },
        { 
          :label => t('layout_action.lista_espera'), 
          :image => "actions/cursos/alumnos.png", 
          :url => {:action => 'lista_espera', :id => @record}
        },
        {
          :label => t('layout_action.asistencias'), 
          :image => "actions/cursos/asistencia.png", 
          :url => {:action => 'asistencia', :id => @record}
        },
        {
          :label => t('layout_action.profesores'), 
          :image => "actions/cursos/profesores.png", 
          :url => {:action => 'listar_profesores', :id => @record}
        },
        {
          :label => t('layout_action.coordinadores'), 
          :image => "actions/cursos/coordinadores.png", 
          :url => {:action => 'listar_coordinadores', :id => @record}
        }
      ]
    end
    render_layout_actions actions 
  end

  # List columns

  def alumnos_column(record)
    num_als = "#{record.formaciones.count(:conditions => ["estado in (?)", ['cancelado', 'matriculado']])} als. (plazas libres. #{record.num_plazas_libres || '-'})"
    link_to num_als, {:action => 'listar_alumnos', :id => record}
  end

  def estado_column(record)
    record.estado.blank? ? '-' : estado_label(record.estado)
  end

  def lugar_column(record)
    record.aula.nombre_aforo if record.aula
  end

  # Form columns

  def banco_id_form_column(record, input_name)
    nice_select input_name, Banco, record.banco_id
  end

  def aula_id_form_column(record, input_name)
    nice_select input_name, Aula, record.aula_id, :options => Aula.find(:all, :order => 'nombre').map {|a| [a.nombre_aforo, a.id.to_s]}
  end

  def temario_form_column(record, input_name)
    text_area :record, :temario, :cols => "100%", :rows => 20
  end

  def estado_form_column(record, input_name)
    if record.new_record? or not Curso::ESTADOS_FINALES.include?((record.estado.to_sym rescue nil))
      select :record, :estado, Curso::ESTADOS_ACTIVOS.map{|i| [estado_label(i), i.to_s]}, {}, :name => input_name
    else
      estado_label record.estado
    end
  end

  def fecha_ini_form_column(record, input_name)
    #Metemos input_name porque se usan también en sub-forms
    calendar_date_select :record, :fecha_ini, :name => input_name, :class => 'text-input fecha_ini-input date-input', :alt => 'fecha'
  end

  def fecha_fin_form_column(record, input_name)
    #Metemos input_name porque se usan también en sub-forms
    calendar_date_select :record, :fecha_fin, :name => input_name, :class => 'text-input fecha_fin-input date-input', :alt => 'fecha'
  end

  def fecha_limite_matricula_form_column(record, input_name)
    calendar_date_select :record, :fecha_limite_matricula, :name => input_name, :class => 'text-input fecha_limite_matricula-input datetime-input', :alt => 'fechahora'
  end

  def fecha_inicio_matricula_form_column(record, input_name)
    calendar_date_select :record, :fecha_inicio_matricula, :class => 'text-input fecha_inicio_matricula-input datetime-input', :alt => 'fechahora'
  end

  def fecha_limite_devolucion_form_column(record, input_name)
    calendar_date_select :record, :fecha_limite_devolucion, :class => 'text-input fecha_limite_devolucion-input datetime-input', :alt => 'fechahora'
  end

  def fecha_solicitud_form_column(record, input_name)
    #Metemos input_name porque se usan también en sub-forms
    calendar_date_select :record, :fecha_solicitud, :name => input_name, :class => 'text-input fecha_solicitud-input date-input', :alt => 'fecha'
  end

  def fecha_obtencion_form_column(record, input_name)
    #Metemos input_name porque se usan también en sub-forms
    calendar_date_select :record, :fecha_obtencion, :name => input_name, :class => 'text-input fecha_obtencion-input date-input', :alt => 'fecha'
  end

  def hora_ini_form_column(record, input_name)
    text_field :record, :hora_ini, :class => 'text-input hora_ini-input', :size => 3, :name => input_name, :alt => 'time'
  end

  def hora_fin_form_column(record, input_name)
    text_field :record, :hora_fin, :class => 'text-input hora_fin-input', :size => 3, :name => input_name, :alt => 'time'
  end

  def porc_asistencia_minima_form_column(record, input_name)
    text_field :record, :porc_asistencia_minima, :value => (record.porc_asistencia_minima || PORC_MIN_ASISTENCIA), :class => 'text-input porc_asistencia_minima-input', :size => 3, :name => input_name, :alt => 'integer'
  end

  # Subform widgets
  def entidad_acreditadora_form_column(record, input_name)
    nice_select input_name, EntidadAcreditadora, record.entidad_acreditadora_id, :options => EntidadAcreditadora.find(:all, :order => 'nombre').map {|ea| [ea.nombre, ea.id.to_s]}
  end

  #Search fields
  def fecha_ini_search_column(record, input_name)
    calendar_date_select(:record, :fecha_ini, :class => 'text-input fecha_ini-input date-input', :name => input_name+"[from]", :alt => 'fecha')+"&nbsp;-&nbsp;"+calendar_date_select(:record, :fecha_ini, :class => 'text-input fecha_ini-input date-input', :name => input_name+"[to]", :alt => 'fecha')
  end

  def fecha_fin_search_column(record, input_name)
    calendar_date_select(:record, :fecha_fin, :class => 'text-input fecha_fin-input date-input', :name => input_name+"[from]", :alt => 'fecha')+"&nbsp;-&nbsp;"+calendar_date_select(:record, :fecha_fin, :class => 'text-input fecha_fin-input date-input', :name => input_name+"[to]", :alt => 'fecha')
  end

  def estado_search_column(record, input_name)
      select :record, :estado, [[I18n.t("forms.bool.undef"), nil]]+Curso::ESTADOS_ACTIVOS.map{|i| [estado_label(i), i.to_s]}, {}, :name => input_name
  end
end
