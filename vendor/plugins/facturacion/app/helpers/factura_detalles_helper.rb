module FacturaDetallesHelper
  # Form columns
  [
    ["cantidad", {}], 
    ["precio", {}], 
    ["impuesto", {}], 
    ["total", {}], 
    #["", {:class => 'SelectBox', :options => [[true, 'Sí'], [false, 'No']]}] 
    ["cliente_id", {:class => 'SelectBox', :options => 
      Cliente.find(:all).map {|cl| [{:tipo => cl.class.to_s, :id => cl.id}, cl.nombre]}}], 
    ["concepto_id", {:class => 'SelectBox', :options => 
      Concepto.find(:all).map {|c| [c.id, c.to_label]}}] 
  ].each {|campo|
      options = campo.last.kind_of?(Hash) ? campo.last.inspect : campo.last
      class_eval <<-EOC
        def #{campo.first}_form_column(record, input_name)
            inline_group(record).field :#{campo.first}, {:param_name => input_name, :css_class => 'text-input'}.merge(#{options})
        end 
      EOC
  }
end
