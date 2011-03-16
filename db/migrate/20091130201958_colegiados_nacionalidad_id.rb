class ColegiadosNacionalidadId < ActiveRecord::Migration
  def self.up
    add_column :colegiados, :pais_id, :integer
    Colegiado.connection.execute ("update colegiados set pais_id = (select id from paises where nombre = nacionalidad);")
    remove_column :colegiados, :nacionalidad
  end

  def self.down
    add_column :colegiados, :nacionalidad, :string
    Colegiado.connection.execute ("update colegiados set nacionalidad = (select nombre from paises where id = pais_id);")
    remove_column :colegiados, :pais_id
  end
end
