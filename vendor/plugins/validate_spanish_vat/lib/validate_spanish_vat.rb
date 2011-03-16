module ValidateSpanishVat
  module ClassMethods
    # Implements model level validator for Spanish's VAT number.
    # Usage: 
    #
    # Inside a model with a vat field, simply put
    #
    #   validates_spanish_vat field_name
    #
    def validates_spanish_vat(*attr_names)
      configuration = { :message => 'is invalid', :on => :save }
      configuration.update(attr_names.pop) if attr_names.last.is_a?(Hash)
      
      validates_each(attr_names, configuration) do |record, attr_name, value|
        record.errors.add(attr_name, configuration[:message]) unless CustomValidator::SpanishVAT.validate(String.new(value))
      end
    end
  end
end

module CustomValidator
  class SpanishVAT
    # Main validate function, it runs several regexp's to determine if value is a nif, cif or nie.
    # If so, it runs specific test, else fails
    def self.validate(value)
      case
        when value.match(/[0-9]{8}[a-z]/i)
          return validate_nif(value)
        when value.match(/[a-wyz][0-9]{7}[0-9a-z]/i)
          return validate_cif(value)
        when value.match(/[x][0-9]{7,8}[a-z]/i)
          return validate_nie(value)
      end
      return false
    end

    # Validates NIF
    def self.validate_nif(value)
      letters = "TRWAGMYFPDXBNJZSQVHLCKE"
      check = value.slice!(value.length - 1..value.length - 1).upcase
      calculated_letter = letters[value.to_i % 23].chr
      return check === calculated_letter
    end

    # Validates CIF
    def self.validate_cif(value)
      letter = value.slice!(0).chr.upcase
      check = value.slice!(value.length - 1).chr.upcase

      n1 = n2 = 0
      for idx in 0..value.length - 1
        number = value.slice!(0).chr.to_i
        if (idx % 2) != 0
          n1 += number
        else
          n2 += ((2*number) % 10) + ((2 * number) / 10)
        end
      end
      calculated_number = (10 - ((n1 + n2) % 10)) % 10
      calculated_letter = (64 + calculated_number).chr

      if letter.match(/[QPNS]/)
        return check.to_s == calculated_letter.to_s
      else
        return check.to_i == calculated_number.to_i
      end
    end

    # Validates NIE, in fact is a fake, a NIE is really a NIF with first number changed to capital 'X' letter, so we change the first X to a 0 and then try to
    # pass the nif validator
    def self.validate_nie(value)
      value[0] = '0'
      value.slice(0) if value.size > 9
      validate_nif(value)
    end
  end
end