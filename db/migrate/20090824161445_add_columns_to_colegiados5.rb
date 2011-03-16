class AddColumnsToColegiados5 < ActiveRecord::Migration
  def self.up
    rename_column :colegiados, :titular_cuenta, :nombre_titular_cuenta
    add_column :colegiados, :titular_cuenta, :boolean
    add_column :colegiados, :domicilio_titular_cuenta, :string
    add_column :colegiados, :plaza_domicilio_titular_cuenta, :string
    add_column :colegiados, :cp_titular_cuenta, :string
  end

  def self.down
    remove_column :colegiados, :cp_titular_cuenta
    remove_column :colegiados, :plaza_domicilio_titular_cuenta
    remove_column :colegiados, :domicilio_titular_cuenta
    remove_column :colegiados, :titular_cuenta
    rename_column :colegiados, :nombre_titular_cuenta, :titular_cuenta
  end
end
