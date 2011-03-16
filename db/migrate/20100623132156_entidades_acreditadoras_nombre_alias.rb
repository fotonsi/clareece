class EntidadesAcreditadorasNombreAlias < ActiveRecord::Migration
  def self.up
    add_column :entidades_acreditadoras, :nombre_alias, :string
  end

  def self.down
    remove_column :entidades_acreditadoras, :nombre_alias
  end
end
