# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  include LayoutHelper
  include ViewHelper
  include TableLayoutHelper
  include TabbedLayoutHelper
  include I18nHelper
  include NiceFieldsHelper
  include SelectOptionsHelper

  # messages

  def load_warning(record)
    messages = record.respond_to?(:warning_messages) ? record.warning_messages : []
    return nil if messages.empty?
    flash[:warning] = '<ul>'+messages.map {|m| "<li>#{m}</li>"}.join('')+'</ul>'
  end

  def show_flash
    out = %|<div id="#{flash_messages_id}">| 
    [:notice, :error, :warning].each do |flash_type|
      if ft = flash[flash_type]
        messages = ft.is_a?(Array) ? ft.join('<br />') : ft
        out += %|<div class="flash-#{flash_type}">#{ messages }</div>|
      end
    end
    out << %|</div>|
    flash.clear
    return out
  end

  def flash_messages_id
    "flash-messages"
  end

end
