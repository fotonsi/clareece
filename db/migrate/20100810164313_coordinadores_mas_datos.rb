class CoordinadoresMasDatos < ActiveRecord::Migration
  def self.up
    add_column :coordinadores, :localidad_id, :integer
    add_column :coordinadores, :num_cuenta, :string, :limit => 20
    add_column :coordinadores, :email, :string
    rename_column :coordinadores, :nif, :doc_identidad
    add_column :coordinadores, :tipo_doc_identidad, :string
  end

  def self.down
    remove_column :coordinadores, :tipo_doc_identidad
    rename_column :coordinadores, :doc_identidad, :nif
    remove_column :coordinadores, :email
    remove_column :coordinadores, :num_cuenta
    remove_column :coordinadores, :localidad_id
  end
end
