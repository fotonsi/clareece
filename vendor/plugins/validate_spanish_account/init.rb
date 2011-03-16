# Include hook code here
require 'validate_spanish_account'

class ActiveRecord::Base
  extend ValidateSpanishAccount::ClassMethods
end