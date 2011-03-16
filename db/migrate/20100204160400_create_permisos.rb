class CreatePermisos < ActiveRecord::Migration
  def self.up
    create_table :permisos do |t|
      t.string :nombre, :descripcion
      t.timestamps
    end
  end

  def self.down
    drop_table :permisos
  end
end
