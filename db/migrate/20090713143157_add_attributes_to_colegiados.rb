class AddAttributesToColegiados < ActiveRecord::Migration
  def self.up
    add_column :colegiados, :domiciliar_recibos, :boolean
  end

  def self.down
    remove_column :colegiados, :domiciliar_recibos
  end
end
