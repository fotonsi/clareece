class BancosCodEntidad < ActiveRecord::Migration
  def self.up
    add_column :bancos, :cod_entidad, :integer, :limit => 4
    Banco.connection.execute('update bancos set cod_entidad = id;')
  end

  def self.down
    remove_column :bancos, :cod_entidad
  end
end
