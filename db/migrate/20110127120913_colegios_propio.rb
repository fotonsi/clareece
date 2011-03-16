class ColegiosPropio < ActiveRecord::Migration
  def self.up
    add_column :colegios, :propio, :boolean
  end

  def self.down
    remove_column :colegios, :propio
  end
end
