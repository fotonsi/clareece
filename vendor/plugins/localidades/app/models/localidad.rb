class Localidad < ActiveRecord::Base
  belongs_to :provincia

  def to_label
    %|CP: #{cp} - #{nombre} - #{provincia.nombre}|
  end

  def provincia_nombre
    provincia ? provincia.nombre : nil
  end

end
