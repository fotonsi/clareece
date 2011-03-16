class ProfesoresMasDatos < ActiveRecord::Migration
  def self.up
    add_column :profesores, :localidad_id, :integer
    add_column :profesores, :num_cuenta, :string, :limit => 20
    add_column :profesores, :email, :string
    rename_column :profesores, :nif, :doc_identidad
    add_column :profesores, :tipo_doc_identidad, :string
  end

  def self.down
    remove_column :profesores, :tipo_doc_identidad
    rename_column :profesores, :doc_identidad, :nif
    remove_column :profesores, :email
    remove_column :profesores, :num_cuenta
    remove_column :profesores, :localidad_id
  end
end
