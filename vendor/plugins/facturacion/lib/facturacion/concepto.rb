module Facturacion
  module Concepto
    
    module ActMethods
      # Options:
      # *  <tt>:methods</tt> - Associations between concepto's methods and object's methods.
      # *  <tt>:conditions</tt> - Only creates the concepto if the object satisfies the conditions.
      #
      # Examples:
      #   has_concepto :methods => {:descripcion => :to_label}
      #   has_concepto :conditions => ["precio > ?" , 0.5]
      def has_concepto(options = {})
        #TODO Añadir :conditions para restringir la creación de conceptos para determinados objetos.
        extend ClassMethods unless (class << self; included_modules; end).include?(ClassMethods)
        include InstanceMethods unless included_modules.include?(InstanceMethods)
        self.concepto_options = options
      end
    end

    module ClassMethods
      def self.extended(base)
        base.cattr_accessor :concepto_options
        base.has_one :concepto, :as => :objeto, :dependent => :destroy 
        base.before_save :add_concepto
      end
    end

    module InstanceMethods
      def add_concepto
        if not concepto
          attributes = {}
          [:descripcion, :codigo].each{|attb|
            if concepto_options[attb]
              attributes[attb] = send(concepto_options[attb])
            else
              method = "#{attb}_concepto" 
              attributes[attb] = respond_to?(method) ? send(method) : warn("#{self.class.name} debe definir ##{method}")
            end
          }
          self.concepto = ::Concepto.new(attributes)
        end
      end
    end

  end
end
