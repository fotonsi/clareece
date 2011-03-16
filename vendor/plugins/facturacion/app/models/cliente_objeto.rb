class ClienteObjeto < ActiveRecord::Base
  belongs_to :cliente, :polymorphic => true
  belongs_to :objeto, :polymorphic => true
end
