class CreateCajaCuadres < ActiveRecord::Migration
  def self.up
    create_table :caja_cuadres do |t|
      t.integer :cent_1, :cent_2, :cent_5, :cent_10, :cent_20, :cent_50
      t.integer :eur_1, :eur_2, :eur_5, :eur_10, :eur_20, :eur_50, :eur_100, :eur_200, :eur_500
      t.float :total_caja, :total_movimientos
      t.timestamps
    end
  end

  def self.down
    drop_table :caja_cuadres
  end
end
