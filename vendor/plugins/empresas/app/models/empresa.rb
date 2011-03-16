class Empresa < ActiveRecord::Base
  has_many :sedes, :dependent => :nullify
  belongs_to :localidad
  has_many :precios, :as => :origen
  has_many :adjuntos, :as => :parent, :dependent => :destroy, :conditions => {:saved_as => nil}

  include SecurityForPluginEmpresas

  def to_label
    self.nombre
  end

end
