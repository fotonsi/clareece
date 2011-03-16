class CreateBancos < ActiveRecord::Migration
  def self.up
    create_table :bancos do |t|
      t.string :nombre
      t.timestamps
    end
  end

  def self.down
    drop_table :bancos
  end
end
