class CreateRecibos < ActiveRecord::Migration
  def self.up
    create_table :recibos do |t|
      t.string :concepto, :concepto1, :concepto2, :concepto3, :concepto4, :concepto5, :concepto6
      t.float :importe, :importe1, :importe2, :importe3, :importe4, :importe5, :importe6, :importe_total
      t.string :concepto_de, :concepto_de1, :concepto_de2, :concepto_de3, :concepto_de4, :concepto_de5, :concepto_de6 
      t.belongs_to :remesa

      t.timestamps
    end
  end

  def self.down
    drop_table :recibos
  end
end
