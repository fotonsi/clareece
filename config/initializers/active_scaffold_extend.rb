class Object

  # Se permite definir traducciones por controlador.
  def as_(key, options = {})
    unless key.blank?
      controller = Thread.current[:controller] || "application"
      text = I18n.translate "#{controller}.#{key}", {:scope => :active_scaffold, :default => [key.to_sym, (key.is_a?(String) ? key : key.to_s.titleize)]}.merge(options)
    end
    text ||= key
    text
  end

end


module ActiveScaffold
  module Helpers
    module IdHelpers
      def active_scaffold_information_id
        "#{controller_id}-information"
      end

      def active_scaffold_list_spinner_id
        "#{controller_id}-list-spinner"
      end

      # AS bug working with firefox 3.5
      def controller_id
        @controller_id ||= 'as_' + (params[:eid] || params[:parent_controller] || params[:controller]).gsub("/", "__")
      end
    end
  end
end
