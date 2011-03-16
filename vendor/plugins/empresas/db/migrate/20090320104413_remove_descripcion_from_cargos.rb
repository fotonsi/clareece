class RemoveDescripcionFromCargos < ActiveRecord::Migration
  def self.up
    remove_column :cargos, :descripcion
  end

  def self.down
    add_column :cargos, :descripcion, :string
  end
end
