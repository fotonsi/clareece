class ColegiadoProfesion < ActiveRecord::Base
  belongs_to :colegiado
  belongs_to :profesion
end
