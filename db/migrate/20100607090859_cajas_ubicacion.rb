class CajasUbicacion < ActiveRecord::Migration
  def self.up
    add_column :cajas, :ubicacion, :integer
    add_column :cajas, :nombre, :string
  end

  def self.down
    remove_column :cajas, :nombre
    remove_column :cajas, :ubicacion
  end
end
