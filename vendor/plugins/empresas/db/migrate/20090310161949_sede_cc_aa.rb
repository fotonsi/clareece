class SedeCcAa < ActiveRecord::Migration
  def self.up
    add_column :sedes, :cc_aa, :string
  end

  def self.down
    remove_column :sedes, :cc_aa
  end
end
