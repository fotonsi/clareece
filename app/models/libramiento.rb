class Libramiento < ActiveRecord::Base

  def importe_letra
    require 'number_to_words'
    partes = ("%2.2f" % importe.abs).to_s.split(".")
    "#{partes[0].to_i.to_words}#{" con #{partes[1].to_i.to_words} céntimos" unless partes[1] == "00"}".upcase.tr('áéíóú', 'ÁÉÍÓÚ')
  end
end
