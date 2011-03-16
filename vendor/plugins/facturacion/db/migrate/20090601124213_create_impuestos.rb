class CreateImpuestos < ActiveRecord::Migration
  def self.up
    create_table :impuestos do |t|
      t.string :nombre
      t.float :valor
      t.timestamps
    end
    Impuesto.create(:nombre => 'I.G.I.C. 0%', :valor => 0)
    Impuesto.create(:nombre => 'I.G.I.C. 2%', :valor => 2)
    Impuesto.create(:nombre => 'I.G.I.C. 5%', :valor => 5)
    Impuesto.create(:nombre => 'I.G.I.C. 9%', :valor => 9)
    Impuesto.create(:nombre => 'I.G.I.C. 13%', :valor => 13)
    Impuesto.create(:nombre => 'I.G.I.C. 20%', :valor => 20)
    Impuesto.create(:nombre => 'I.G.I.C. 35%', :valor => 35)
  end

  def self.down
    drop_table :impuestos
  end
end
