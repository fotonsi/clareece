class CreateCajas < ActiveRecord::Migration
  def self.up
    create_table :cajas do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :cajas
  end
end
