require 'active_record'

module ActiveRecord
  module NumericExtend
    def self.included(base)
      base.send(:extend, ClassMethods)
    end

    module ClassMethods
      # Set save options for numeric columns.
      def numeric_fields(options)
        raise "MethodAlreadyDefined" if instance_methods.include? "write_attribute_with_decimals"

        default_value = options[:default_value] || 0
        decimals = options[:decimals] || 2
        masked = options[:masked] || false

        include InstanceMethods
        before_validation {|record| record.save_with_default_value(default_value)}

        class_eval <<-EOC
          # Clear masked number columns
          def remove_number_mask(value)
            String === value ? value.delete(".").tr(",", ".") : value 
          end

          def write_attribute_with_numeric_extend(column_name, value)
            column = self.class.content_columns.detect{|c| c.name == column_name}
            
            if column and %w(integer float).include?(column.type.to_s)
              v = value.blank? ? #{default_value} : value 
              if #{decimals} and v and column.type == :float
                v = remove_number_mask(value) if(#{masked} and String === v and v.match(','))
                factor = 10 ** #{decimals}
                bv = BigDecimal.new(v.to_s)
                rounded = (bv * factor).round / factor
                v = ('%.0#{decimals}f'% rounded).to_f
              else
                v = remove_number_mask(value) if #{masked}
              end
              v.from_widget = value.from_widget if value.respond_to?('from_widget')
              value = v
            end
            write_attribute_without_numeric_extend column_name, value
          end
          alias_method_chain :write_attribute, :numeric_extend
        EOC
      end
    end

    module InstanceMethods
      # Calls write_attribute method for columns aren't in the attributes for save.
      def save_with_default_value(default_value)
        self.class.content_columns.select{|c| [:integer, :float].include? c.type}.each{|column|
          self.send("#{column.name}=", default_value) if self.send(column.name).blank?
        }
      end
    end

  end
end
