module ValidateSpanishAccount
  module ClassMethods
    # Implements model level validator for Spanish's Bank Accounts numbers.
    # Usage: 
    #
    # Inside a model with an account field, simply put
    #
    #   validates_spanish_account field_name
    #
    def validates_spanish_account(*attr_names)
      configuration = { :message => 'is invalid', :on => :save }
      configuration.update(attr_names.pop) if attr_names.last.is_a?(Hash)
      
      validates_each(attr_names, configuration) do |record, attr_name, value|
        record.errors.add(attr_name, configuration[:message]) unless CustomValidator::SpanishAccount.validate(String.new(value))
      end
    end
  end
end

module CustomValidator
  class SpanishAccount
    # Main Validation method, just stripes out...
    def self.validate(value)
      return false if value.length != 20
      return (get_control_digit("00" + value[0,8]).to_s + get_control_digit(value[-10,10]).to_s) == value[8,2]
    end
    
    def self.get_control_digit(value)
      values = [1,2,4,8,5,10,9,7,3,6]
      digit = 0
      for idx in 0..9
        digit += (value[idx,1].to_i * values[idx])
      end
      digit = 11 - (digit % 11)
      case digit
      when 11
        return 0
      when 10
        return 1
      else
        return digit
      end
    end
  end
end