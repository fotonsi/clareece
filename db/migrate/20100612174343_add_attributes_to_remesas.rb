class AddAttributesToRemesas < ActiveRecord::Migration
  def self.up
    add_column :remesas, :fecha_generacion, :date
    add_column :remesas, :fecha_entrega, :date
    add_column :remesas, :fecha_anulacion, :date
  end

  def self.down
    remove_column :remesas, :fecha_anulacion
    remove_column :remesas, :fecha_entrega
    remove_column :remesas, :fecha_generacion
  end
end
