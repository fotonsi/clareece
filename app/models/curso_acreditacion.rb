class CursoAcreditacion < ActiveRecord::Base
  belongs_to :curso
  belongs_to :entidad_acreditadora
end
