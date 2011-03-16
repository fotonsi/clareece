class InformeRegistro < ActiveRecord::Migration
  def self.up
    add_column :informes, :registro, :boolean
  end

  def self.down
    remove_column :informes, :registro
  end
end
