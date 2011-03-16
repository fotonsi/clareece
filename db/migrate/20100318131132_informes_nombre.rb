class InformesNombre < ActiveRecord::Migration
  def self.up
    add_column :informes, :nombre, :string
  end

  def self.down
    remove_column :informes, :nombre
  end
end
