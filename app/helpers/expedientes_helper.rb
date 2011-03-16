module ExpedientesHelper

  # Layout

  def layout_actions(record)
    actions = []
    if not record.new_record?
      actions += [
        {:label => t('layout_action.expedientes'), :title => "Datos del expediente", :image => "actions/expedientes/expediente.png", :url => {:action => 'edit', :id => @record, :mode => params[:mode]}},
        {:label => t('layout_action.expedientes_asociados'), :title => "Expedientes relacionados", :image => "actions/expedientes/exp_relacionados.png", :url => {:action => 'listar_expedientes', :id => @record, :mode => params[:mode]}},
        {:label => t('layout_action.notas'), :title => 'Notas del expediente', :image => "actions/expedientes/notas.png", :url => {:action => 'listar_notas', :id => @record, :mode => params[:mode]}},
      ]
    end
    render_layout_actions actions 
  end


  # Form columns

  def titulo_form_column(record, input_name)
    text_field_tag "record[titulo]", (record.titulo || params["titulo"]), :class => 'text-input', :size => '40'
  end
end
