module Menu
  include MenuOptions
end

module ApplicationHelper

  # Helper para dibujar el menú principal de la aplicación
  def render_menu(options, level = 1)
    %|<ul class="navigation-#{level}">| + menu_recursive(options, level) + "</ul>"
  end
  
  def menu_recursive(options, level)
    return "" if options.nil?
    if options.empty?
      out = ""
    else
      option = options.first
      label = option[:label]
      label += "<span>&raquo;</span>" if not option[:submenu].blank? and level != 1
      label = image_tag(option[:image], :style => "vertical-align: top;") + " " + label if option[:image]

      out = ("<li>" + link_to(label, (option[:url].blank? ? "#" : option[:url]), option[:html_options]))

      if option[:submenu]
        out +=(render_menu(option[:submenu], level + 1) + "</li>" + menu_recursive(options[1..-1], level))
      else
        out += ("</li>" + menu_recursive(options[1..-1], level))
      end
    end

    return out 
  end

  # Localizador de la opción del menú en la que nos encontramos.
  def locator(menu)
    menu_options = [] 
    menu.each{|option| 
      if option[:submenu]
        # Opciones con submenú
        option[:submenu].each{|submenu|
          menu_options << [option[:label], submenu[:label], submenu[:url][:controller], submenu[:url][:action]]
        }
      else
        # Opciones sin submenú
        menu_options << [option[:label], nil, option[:url][:controller], option[:url][:action]]
      end
    } if menu
    current = menu_options.detect{|i| (i[2] == params[:controller] and i[3] == params[:action])} 
    current ||= menu_options.detect{|i|  i[2] == params[:controller]}

    str = ""
    if current and current[1]
      str << "#{image_tag('layout/locator/arrow1.png', :style => "vertical-align: bottom;")} " + 
      "#{current.first} #{image_tag('layout/locator/arrow2.png', :style => "vertical-align: top;")} #{current[1]}"
    elsif current
      str << "#{image_tag('layout/locator/arrow1.png', :style => "vertical-align: bottom;")} " + "#{current.first}"
    end
    if @record
      str << %|
        <span class="locator_block">#{(respond_to?(:layout_title) ? layout_title(@record) : @record.to_label) if @record}</span>
      |
    end
    str = %|<div style="width: 80%; float: left; white-space: nowrap;">#{str}</div>|
    str << %|
      <div style="float: left; width: 19%; text-align: right;">
        #{controller.current_user.nombre_completo if controller.current_user}#{link_to(I18n.t('application.logout'), {:controller => 'usuarios', :action => 'logout'}, :style => 'color: yellow;') if controller.current_user}
      </div>
    |
  end

end
