class Centro < ActiveRecord::Base
  def to_label
    self.nombre
  end
end
