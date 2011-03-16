class Ausencia < ActiveRecord::Base
  belongs_to :curso
  belongs_to :alumno, :polymorphic => true
end
