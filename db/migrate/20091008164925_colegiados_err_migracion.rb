class ColegiadosErrMigracion < ActiveRecord::Migration
  def self.up
    add_column :colegiados, :err_migracion, :text
  end

  def self.down
    remove_column :colegiados, :err_migracion
  end
end
