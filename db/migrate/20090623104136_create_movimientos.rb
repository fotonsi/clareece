class CreateMovimientos < ActiveRecord::Migration
  def self.up
    create_table :movimientos do |t|
      t.references :pagador, :polymorphic => true 
      t.references :caja
      t.float :importe
      t.timestamps
    end
  end

  def self.down
    drop_table :movimientos
  end
end
