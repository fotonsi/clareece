class AddAttributesToEmpleados2 < ActiveRecord::Migration
  def self.up
    add_column :empleados, :en_nomina, :boolean
  end

  def self.down
    remove_column :empleados, :en_nomina
  end
end
