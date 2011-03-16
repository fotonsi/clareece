class Empleado < ActiveRecord::Base
  belongs_to :sede
  belongs_to :cargo
  has_many :experiencia_profesionales
  has_many :formacion_academicas
  has_many :formacion_especificas
  has_many :accidente_laborales

  include SecurityForPluginEmpresas

  def to_label
    "#{self.nombre_completo} - #{self.nif}"
  end

  # Columnas virtuales
  def nombre_completo
    "#{self.nombre} #{self.apellido1} #{self.apellido2}"
  end

  def telefonos
    %w(telefono1 telefono2 telefono3).map{|tlf| send tlf }.compact
  end
end
