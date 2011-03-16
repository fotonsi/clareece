class CursoHorario < ActiveRecord::Base
  belongs_to :curso

  validates_presence_of :fecha_ini, :fecha_fin, :hora_ini, :hora_fin
end
