class ColegiadoDeudaASaldar < ActiveRecord::Migration
  def self.up
    add_column :colegiados, :deuda_a_saldar, :float
  end

  def self.down
    remove_column :colegiados, :deuda_a_saldar
  end
end
