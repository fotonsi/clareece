class TitulosGestionDocumentalId < ActiveRecord::Migration
  def self.up
    add_column :titulos, :gestion_documental_id, :integer
  end

  def self.down
    remove_column :titulos, :gestion_documental_id
  end
end
