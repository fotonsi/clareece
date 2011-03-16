class CreateColegios < ActiveRecord::Migration
  def self.up
    create_table :colegios do |t|
      t.string :codigo, :nombre, :direccion, :telefono, :fax, :email
      t.belongs_to :localidad
      t.string :entidad, :oficina, :dc, :cuenta
      t.float :recargo_bancario
      t.integer :dia_trans_deuda
      t.boolean :actual

      t.timestamps
    end
  end

  def self.down
    drop_table :colegios
  end
end
