# Include hook code here
require 'validate_spanish_vat'

class ActiveRecord::Base
  extend ValidateSpanishVat::ClassMethods
end