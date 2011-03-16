class ColegioCif < ActiveRecord::Migration
  def self.up
    add_column :colegios, :cif, :string
  end

  def self.down
    remove_column :colegios, :cif
  end
end
