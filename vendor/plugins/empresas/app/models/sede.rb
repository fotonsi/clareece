class Sede < ActiveRecord::Base
  belongs_to :empresa
  belongs_to :localidad
  has_many :empleados, :dependent => :nullify
  has_many :precios, :as => :origen
  has_many :adjuntos, :as => :parent, :dependent => :destroy

  include SecurityForPluginEmpresas

  def to_label
    self.nombre
  end

  def label_for_select
    "#{empresa.nombre} - #{nombre}"
  end

end
