class AddAttributesToEmpleados < ActiveRecord::Migration
  def self.up
    add_column :empleados, :cargo_id, :integer
  end

  def self.down
    remove_column :empleados, :cargo_id
  end
end
