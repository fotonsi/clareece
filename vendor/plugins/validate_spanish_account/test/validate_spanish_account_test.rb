require File.expand_path(File.join(File.dirname(__FILE__), '../lib/validate_spanish_account.rb'))
require 'test/unit'

class ValidateSpanishAccountTest < Test::Unit::TestCase
  def test_validate_spanish_account
    assert CustomValidator::SpanishAccount.validate('21003606002100256574') # Correct Spanish Account
    assert !CustomValidator::SpanishAccount.validate('21003606002100256575') # Incorrect Spanish Account
  end  
end
