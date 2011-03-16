module ClientesEmpresasHelper
  # Form columns
  [ 
    ["nombre", {}],
    ["cif", {}],
    ["direccion", {}],
    ["telefono1", {}],
    ["telefono2", {}],
    ["fax", {}], 
    ["email", {}],
    ["ccaa", {}]
  ].each {|campo|
      options = campo.last.kind_of?(Hash) ? campo.last.inspect : campo.last
      class_eval <<-EOC
        def #{campo.first}_form_column(record, input_name)
            inline_group(record).field :#{campo.first}, {:param_name => input_name, :css_class => 'text-input'}.merge(#{options})
        end 
      EOC
  }
end
