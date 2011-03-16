class Cargo < ActiveRecord::Base
  has_many :empleados

  include SecurityForPluginEmpresas

  def to_label
    nombre
  end
end
