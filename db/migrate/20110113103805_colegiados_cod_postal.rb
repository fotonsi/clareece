class ColegiadosCodPostal < ActiveRecord::Migration
  def self.up
    add_column :colegiados, :cod_postal, :string, :limit => 5
  end

  def self.down
    remove_column :colegiados, :cod_postal
  end
end
