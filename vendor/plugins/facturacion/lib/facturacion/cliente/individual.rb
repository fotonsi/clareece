module Facturacion
  module Cliente
    module Individual
      # Código para los clientes con semántica de cliente individual (físico, jurídico, etc).
      def cliente_methods(methods) 
        methods.each{|method| 
          class_eval <<-EOC
            def #{method} 
              return read_attribute(:#{method}) unless objeto 
              if not objeto.cliente_options[:methods][:#{method}].nil? 
                objeto.send(objeto.cliente_options[:methods][:#{method}]) 
              else 
                objeto.respond_to?(:#{method}) ? objeto.send(:#{method}) : nil  
              end        
            end 
          EOC
        } 
      end

    end
  end
end
