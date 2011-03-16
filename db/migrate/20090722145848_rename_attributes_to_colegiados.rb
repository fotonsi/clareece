class RenameAttributesToColegiados < ActiveRecord::Migration
  def self.up
    rename_column :colegiados, :domiciliar_recibos, :domiciliar_pagos
  end

  def self.down
    rename_column :colegiados, :domiciliar_pagos, :domiciliar_recibos
  end
end
