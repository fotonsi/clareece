class ColegiadosSuscripciones < ActiveRecord::Migration
  def self.up
    add_column :colegiados, :revista, :boolean
    add_column :colegiados, :eboletin, :boolean
  end

  def self.down
    remove_column :colegiados, :eboletin
    remove_column :colegiados, :revista
  end
end
