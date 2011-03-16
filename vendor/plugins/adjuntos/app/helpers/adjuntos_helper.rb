module AdjuntosHelper

  def adjuntos(record)
    if record.new_record?
      link_to_function(image_tag('plugin_adjuntos/clip.gif', :style => 'vertical-align: bottom;', :title => 'Ficheros Adjuntos'),
        "alert('Debe crear primero el elemento para poder asociarle ficheros adjuntos.')").to_s + "<label>(0)</label>"
    else
      remote_element_id = "boton_adjuntos_#{generate_temporary_id}"

      link_to_function(image_tag('plugin_adjuntos/clip.gif', :style => 'vertical-align: bottom;', :title => 'Ficheros Adjuntos'),
        %|new Ajax.Request(#{url_for(:controller => 'adjuntos', :action => 'adjuntar').to_json},
          { method: "GET",
            parameters: {
              parent_type: '#{record.class}', 
              parent_id: #{record.id.to_json}, 
              remote_element_id: #{remote_element_id.to_json}
          }
        });|).to_s + %|<label id='#{remote_element_id}'>(#{record.adjuntos.size})</label>|
    end
  end

end
