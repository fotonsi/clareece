class ColegiadosMigrado < ActiveRecord::Migration
  def self.up
    add_column :colegiados, :migrado, :boolean
  end

  def self.down
    remove_column :colegiados, :migrado
  end
end
