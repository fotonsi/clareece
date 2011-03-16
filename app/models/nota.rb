class Nota < ActiveRecord::Base
  belongs_to :origen, :polymorphic => true
end
