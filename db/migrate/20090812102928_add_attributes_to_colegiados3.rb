class AddAttributesToColegiados3 < ActiveRecord::Migration
  def self.up
    add_column :colegiados, :situacion_colegial, :string
    add_column :colegiados, :exento_pago, :boolean, :default => false
  end

  def self.down
    remove_column :colegiados, :exento_pago
    remove_column :colegiados, :situacion_colegial
  end
end
