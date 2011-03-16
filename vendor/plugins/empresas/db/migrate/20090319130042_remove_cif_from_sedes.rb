class RemoveCifFromSedes < ActiveRecord::Migration
  def self.up
    remove_column :sedes, :cif
  end

  def self.down
    add_column :sedes, :cif, :string
  end
end
