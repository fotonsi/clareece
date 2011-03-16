module Facturacion
  module Cliente
    @@tipos_clientes = [ClienteFisico, ClienteJuridico, ClienteGrupo]
    mattr_reader :tipos_clientes

    module ActMethods
      # Options:
      # *  <tt>:type</tt> - Type of client. Allowed [:cliente_fisico | :cliente_juridico | cliente_grupo]. Defaults :cliente_fisico.
      # *  <tt>:methods</tt> - Hash of associations between client's methods and object's methods.
      # *  <tt>:conditions</tt> - Only creates the client if the object satisfies the conditions.
      #
      # Examples:
      #   has_cliente :type => :cliente_juridico
      #   has_cliente :type => :cliente_fisico, :methods => {:nombre => :to_label}
      #   has_cliente :conditions => ["edad > ?" , 18]
      def has_cliente(options = {})
        #TODO Añadir :conditions para restringir la creación de clientes para determinados objetos.
        extend ClassMethods unless (class << self; included_modules; end).include?(ClassMethods)
        include InstanceMethods unless included_modules.include?(InstanceMethods)

        self.cliente_options = options
        cliente_options[:type] ||= :cliente_fisico 
        cliente_options[:methods] ||= {}

        unless Facturacion::Cliente.tipos_clientes.map{|i| i.to_s.underscore}.include? cliente_options[:type].to_s
          raise ArgumentError, ":type debe ser [#{Facturacion::Cliente.tipos_clientes.map{|i| i.to_s.underscore.to_sym}.join(' | ').inspect}]"
        end
      end
    end

    module ClassMethods
      def self.extended(base)
        base.cattr_accessor :cliente_options
        base.has_many :cliente_objetos, :as => :objeto, :dependent => :destroy
        base.before_create :add_cliente
      end
    end

    module InstanceMethods
      def add_cliente
        if not cliente_objetos.any?{|i| i.objeto == self}
          attributes = {}
          [:nombre].each{|attb|
            if cliente_options[:methods][attb]
              attributes[attb] = send(cliente_options[:methods][attb])
            else
              attributes[attb] = respond_to?(attb) ? send(attb) : warn("#{self.class.name} debe definir ##{attb}")
            end
          }
          cliente_class = cliente_options[:type].to_s.camelize.constantize
          cliente = cliente_class.create(attributes)
          self.cliente_objetos << ClienteObjeto.new(:cliente => cliente)
        end
      end
    end

  end
end
