class AgrandarNumCuenta < ActiveRecord::Migration
  def self.up
    change_column :profesores, :num_cuenta, :string, :limit => 24
    change_column :coordinadores, :num_cuenta, :string, :limit => 24
  end

  def self.down
    change_column :coordinadores, :num_cuenta
    change_column :profesores, :num_cuenta
  end
end
