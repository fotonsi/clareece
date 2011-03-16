class Cliente < ActiveRecord::Base
  belongs_to :origen, :polymorphic => true
  has_many :precios
  has_many :facturas
end
