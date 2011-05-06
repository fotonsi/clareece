module NiceFieldsHelper

  def nice_select(input_name, model, selected_value, args = {})
    unless @nice_select_js_loaded
      content_for :header, javascript_include_tag("nice_select.js")
      @nice_select_js_loaded = true
    end

    select_options = args[:options] || model.all.map {|area| [area.to_label, area.id.to_s]}

    # If there is an 'undefined method `new_****_path`' error in new_polymorphic_path call
    #   a new active_resource is needed for model
    select_tag(input_name, options_for_select(select_options, selected_value.to_s)) +
          %|<script type="text/javascript">new NiceSelect("#{escape_javascript input_name}", "#{escape_javascript new_polymorphic_path(model)}", "#{escape_javascript image_path("nice_select/add.png")}", "#{escape_javascript t("forms.select_empty_option")}", #{selected_value.blank?})</script>|
  end

  def active_scaffold_input_boolean(column, options)
    select_options = []
    select_options << [I18n.t('forms.bool.undef'), nil] if column.column.null
    select_options << [I18n.t('forms.bool.true'), true]
    select_options << [I18n.t('forms.bool.false'), false]

    select_tag(options[:name], options_for_select(select_options, @record.send(column.name)))
  end

  def nice_date_field(object, field, options)
    date_format = options[:date_format] || I18n.t('jquery.date.formats.default')
    first_day = options[:first_day] || 1
    text_field(object, field, :size => options[:size], :class => options[:class])+
    %|<script type="text/javascript">
        jQuery(function($) {$(document).ready(function() {
            $("##{object.to_s}_#{field.to_s}").datepicker({ dateFormat: '#{date_format}', firstDay: #{first_day}, showOn: "button", closeText: '#{I18n.t("active_scaffold.close")}', showButtonPanel: true });
            $("##{object.to_s}_#{field.to_s}").defaultvalue('#{options[:help_text]}');
        })});
      </script>|
  end

  def nice_numeric_field(object, field, options)
    format = options[:format] || I18n.t('jquery.number.formats.default')
    locale = options[:locale] || "es"
    text_field(object, field, :size => options[:size], :class => options[:class])+
    %|<script type="text/javascript">
        jQuery(function($) {
            $("##{object.to_s}_#{field.to_s}").blur(function() {
              $(this).format({ format: '#{format}', locale: '#{locale}'});
            });
            $("##{object.to_s}_#{field.to_s}").format({ format: '#{format}', locale: '#{locale}'});
        });
    </script>|
  end

  def nice_smart_auto_field(object, field, ini_value, options)
    #TODO Cargar campo de texto con el to_label.
    #TODO Mostrar una fila avisando de que hay más resultados o con el total, que no se pueda seleccionar.
    #FIXME Hacer que no busque mientras no paramos de escribir durante un tiempo y que muestre bien el buscando.
    #FIXME Cuando seleccionamos valor coge el id que está oculto.
    url = options.delete(:query_url) || url_for(:action => 'autocomplete_results')
    tip = options.delete(:tip) || 'specify search terms'
    hidd_id = options.delete(:id)
    hidd_name = options.delete(:param_name)
    id = hidd_name ? hidd_name.gsub(/[\[\]]/, '_') : object.to_s+'_'+field.to_s
    model = options.delete(:model) || @record.class.reflections[field].klass
    search_fields = options.delete(:search_fields).map {|f| f.to_s}.join(',')
    txt = ini_value
    val = @record.send(field) if @record
    txt ||= if val.respond_to?('to_autocomplete_label')
              val.to_autocomplete_label
            elsif val.respond_to?('to_label')
              val.to_label
            end
    options[:class] = "#{options[:class] || ''} autocomplete smart_autocomplete_text"
    options[:class] += ' smart_autocomplete_text_with_help' if txt.blank?
    txt_f = text_field_tag("#{id}_text", txt || tip, options.merge(:texttype => "text", :autocomplete => "off", :onfocus => 'if (this.hasClassName("smart_autocomplete_text_with_help")) {this.removeClassName("smart_autocomplete_text_with_help"); this.value = "";}'))
    txt_u = "<ul id='#{id}_results' class='smart_autocomplete_container'></ul>"
    txt_f += respond_to?('raw') ? raw(txt_u) : txt_u
    hidd_f = !object.blank? && !field.blank? ? hidden_field(object, field, :name => hidd_name, :id => (hidd_id || id), :value => (val.id if val)) : hidden_field_tag(hidd_name, (val.id if val), :id => (hidd_id || id))
    txt_f += hidd_f
    js = %|<script type="text/javascript">
          jQuery(function($){
              $('##{id}_text').smartAutoComplete({
                filter: function(term){
                 return $.Deferred(function(dfd){
                    $.getJSON('#{url}?term=' + escape(term) + "&model=#{model}&fields=#{search_fields}&callback=?")
                      .success( function(data){
                        dfd.resolve( $.map(data.records, function(r){ return r; }) );
                      });
                 }).promise();
                },
                resultsContainer: "ul##{id}_results",
                resultFormatter: function(r){ return "<li class='result'>"+r.to_label+'<span display="hidden;">'+r.id+'</span>'+'</li>'},
                minCharLimit: 3, maxResults: 5, delay: 100, forceSelect: false});
       
              $("##{id}_text").bind({
                keyIn: function(ev){
                  //clear existing results
                  $(this).smartAutoComplete().clearResults();
                  
                  //$("ul##{id}_results").html("Cargando...");
                  $("ul##{id}_results").show();
                },
       
                noResults: function(ev){
                  $("ul##{id}_results").html("<li class='error'>Lo sentimos! No se encontraron resultados</li>");
                  $("ul##{id}_results").show();
                  ev.preventDefault();
                },
       
                //we don't need the default behaviour of following events
                //showResults: function(ev) {ev.preventDefault(); },
                itemSelect: function(ev, item){
                  var txt = '';
                  var id = '';
                  if (item) {
                    reg = /^(.*)<span.*>(.*)<\\/span>/;
                    txt = item.innerHTML.match(reg)[1];
                    id = item.innerHTML.match(reg)[2];
                  }
                  $('##{id}').val(id);
                  $('##{id}_text').val(txt);
                  $('##{id}_text').trigger('lostFocus');
                  ev.preventDefault();
                }
              });
          });
    </script>|
    txt_f += respond_to?('raw') ? raw(js) : js
    txt_f
  end
end
