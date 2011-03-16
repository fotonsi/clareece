module TableLayoutHelper

  # Este módulo contiene las definiciones para el #table_layout,
  # el cual ayuda a formularios por tablas

  class TableLayout
    attr_reader :view
    def initialize(view)
      @view = view
    end

    # Filas genéricas
    class Row
      attr_reader :table
      def initialize(table)
        @table = table
      end

      def column(options = {}, &block)
        options[:class] ||=  "tl-column"
        table.view.concat "<td #{options.to_html}>#{block.call}</td>"
      end
    end

    def row(options = {}, &block)
      options[:class] ||= "tl-row"
      row = Row.new(self)
      view.concat "<tr #{options.to_html}>#{view.capture { block.call(row) }}</tr>"
    end

  end


  def table_layout(options = {}, &block)
    options[:class] ||= "tabled-layout"
    layout = TableLayout.new(self)
    concat %|<table #{options.to_html}>#{capture { block.call(layout) }}</table>|
  end

  def as_field(object_name, method)
    view ||= self
    column = view.active_scaffold_config.columns[method]
    if view.is_subsection? column
      html = view.active_scaffold_input_for(column)
    elsif view.is_subform? column and !view.override_form_field?(column)
      html = %|<div class="sub-form">| + 
        view.render(:partial => view.form_partial_for_column(column), :locals => { :column => column }) +
      %|</div>|
      hidden_label = true
    else
      html = view.active_scaffold_input_for(column)
    end

    return <<-EOR
      <div class="label-field" #{'style="display: none;"' if hidden_label}>#{view.label object_name, method}</div>
      <div class="value-field">#{html}</div>
    EOR
  end

end
