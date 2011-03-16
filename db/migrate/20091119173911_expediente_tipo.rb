class ExpedienteTipo < ActiveRecord::Migration
  def self.up
    add_column :expedientes, :tipo, :string
  end

  def self.down
    remove_column :expedientes, :tipo
  end
end
