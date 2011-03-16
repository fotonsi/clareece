class ColegiadoEspecialidad < ActiveRecord::Base
  belongs_to :colegiado
  belongs_to :especialidad
end
