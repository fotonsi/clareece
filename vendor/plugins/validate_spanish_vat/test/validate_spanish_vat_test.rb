require File.expand_path(File.join(File.dirname(__FILE__), '../lib/validate_spanish_vat.rb'))
require 'test/unit'

class ValidateSpanishVatTest < Test::Unit::TestCase
  def test_validate_nif
    assert CustomValidator::SpanishVAT.validate('00000000T') # Correct NIF
    assert !CustomValidator::SpanishVAT.validate('00000000L') # Incorrect NIF
  end
  
  def test_validate_nie
    assert CustomValidator::SpanishVAT.validate('X0000000T') # Correct NIE
    assert !CustomValidator::SpanishVAT.validate('X0000000L') # Incorrect NIE
    assert CustomValidator::SpanishVAT.validate('X00000000T') # Correct NIE
    assert !CustomValidator::SpanishVAT.validate('X00000000L') # Incorrect NIE
  end

  def test_validate_cif
    assert CustomValidator::SpanishVAT.validate('B25630633') # Correct CIF
    assert !CustomValidator::SpanishVAT.validate('B25630634') # Incorrect CIF
    assert CustomValidator::SpanishVAT.validate('Q5355054G') # Correct CIF
    assert !CustomValidator::SpanishVAT.validate('Q5355054R') # Incorrect CIF
  end
end
