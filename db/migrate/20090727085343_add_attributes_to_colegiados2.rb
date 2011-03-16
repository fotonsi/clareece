class AddAttributesToColegiados2 < ActiveRecord::Migration
  def self.up
    add_column :colegiados, :saldar_deuda, :boolean, :default => false
    add_column :colegiados, :importe_deuda, :float, :default => 0
  end

  def self.down
    remove_column :colegiados, :importe_deuda
    remove_column :colegiados, :saldar_deuda
  end
end
