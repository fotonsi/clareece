class CreateEntidadesAcreditadoras < ActiveRecord::Migration
  def self.up
    create_table :entidades_acreditadoras do |t|
      t.string :nombre
      t.timestamps
    end
  end

  def self.down
    drop_table :entidades_acreditadoras
  end
end
