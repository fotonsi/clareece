class ColegiadosDocumentoIdentidad < ActiveRecord::Migration
  def self.up
    add_column :colegiados, :tipo_doc_identidad, :string
    rename_column :colegiados, :nif, :doc_identidad
  end

  def self.down
    rename_column :colegiados, :doc_identidad, :nif
    remove_column :colegiados, :tipo_doc_identidad
  end
end
