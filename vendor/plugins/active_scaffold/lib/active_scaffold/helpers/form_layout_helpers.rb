module ActiveScaffold 
  module Helpers
    module FormLayoutHelpers 
      #Liquid layout helpers
      def active_scaffold_form_layout(title = nil, options = {})
        str = ""
        str += "<fieldset class='form'><legend>#{title}</legend>" if title
        str += "<ol class='form' #{options[:atrs]}>#{yield.join("\n")}</ol>"
        str += "</fieldset>" if title
      end

      #Array representing the columns that will be included
      #cell can be a straight value
      #or can be a hash with the following keys
      # value: it'll be shown as is
      # column: it'll be an active_scaffold column and its label, css_class, ... methods can be used
      #   also, width, label, description and css_class can be passed explicitly
      def row(cells)
        str_arr = ["<li class='form-element'>"]
        cells_w = cells.select {|c| c.kind_of?(Hash) && c[:width]}
        def_width = "#{((100-cells_w.inject(0) {|sum, c| sum+c[:width].to_i})/(cells-cells_w).size).to_i}%" unless cells == cells_w
        cells.each do |e|
          options =  e.kind_of?(Hash) ? e : {:column => e}
          column = options[:column]
          options[:width] ||= def_width
          options[:width] += "%" if options[:width] !~ /%$/
          align = if cells.index(e) == 0
                    "first-element"
                  elsif cells.index(e) == (cells.size - 1)
                    "last-element"
                  end
          options[:css] ||= column.respond_to?("css_class") && !column.css_class.empty? ? column.css_class : align
          
          options[:label] ||= column.respond_to?("label") ? column.label : ''
          options[:description] ||= column.respond_to?("description") ? column.description : '' 
    
          options[:partial] = if options[:value]
                                options[:value]
                              elsif is_subsection? column
                                active_scaffold_input_for(column)
                              elsif is_subform? column and !override_form_field?(column)
                                render(:partial => form_partial_for_column(column), :locals => { :column => column })
                              else
                                active_scaffold_input_for(column)
                              end
          str = %|<dl class='#{options[:css]}' style="display: block; width: #{options[:width]};">
                   <div class="borde_interno">&nbsp;|
          str << %|<label>#{options[:label]}</label>| if options[:label]
          str << %|<dd>#{options[:partial]}
                     <span class='description'>#{options[:description]}</span>
                   </dd>
                   </div>
                 </dl>|
          str_arr << str
        end
        str_arr << "</li>"
        return str_arr.join("\n")
      end

      alias_method :active_scaffold_row, :row
    end
  end
end
