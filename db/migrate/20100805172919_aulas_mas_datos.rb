class AulasMasDatos < ActiveRecord::Migration
  def self.up
    add_column :aulas, :localidad_id, :integer
  end

  def self.down
    remove_column :aulas, :localidad_id
  end
end
