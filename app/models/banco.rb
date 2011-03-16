class Banco < ActiveRecord::Base

  has_many :colegiados

  def to_label
    nombre
  end

end
