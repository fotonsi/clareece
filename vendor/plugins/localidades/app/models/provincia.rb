class Provincia < ActiveRecord::Base
  belongs_to :pais
  has_many :localidades, :dependent => :destroy

  def to_label
    self.nombre
  end
end
