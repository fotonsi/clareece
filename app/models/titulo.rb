class Titulo < ActiveRecord::Base
  belongs_to :formacion
  belongs_to :gestion_documental
end
