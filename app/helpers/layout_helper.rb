module LayoutHelper

  def render_layout_actions(actions)
    out = ""
    actions.each{|action|
      image = action[:image].present? ? image_tag(action[:image]) : ""
      action[:url][:controller] ||= params[:controller]
      current_action = params[:controller] == action[:url][:controller] && params[:action] == action[:url][:action]
      css = current_action ? 'action-active' : 'action' 
      out.concat %|
        <div class="#{css}">
          #{current_action ? "<span title='#{action[:title]}'>#{image} #{action[:label]}</span>" : link_to("#{image} #{action[:label]}", action[:url], :title => action[:title])}
        </div>
      |
    }
    return out
  end

end
