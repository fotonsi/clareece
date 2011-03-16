class String
  def convert(klass)
    method = case klass.name
    when 'Integer'
      "to_i"
    when 'Float'
      "to_f"
    when 'String'
      "to_s"
    else
      "to_s"
    end
    self.send(method)
  end
end
