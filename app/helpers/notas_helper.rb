module NotasHelper

  # List columns

  def texto_column(record)
    truncate(record.texto, :length => 80)
  end

end
