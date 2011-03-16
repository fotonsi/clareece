class Caja < ActiveRecord::Base
  has_many :movimientos, :dependent => :nullify
end
