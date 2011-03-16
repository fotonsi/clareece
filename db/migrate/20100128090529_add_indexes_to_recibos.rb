class AddIndexesToRecibos < ActiveRecord::Migration
  def self.up
    add_index :recibos, [:titular_id, :titular_type]
    add_index :recibos, :titular_id
    add_index :recibos, :titular_type
  end

  def self.down
    remove_index :recibos, :column => :titular_type
    remove_index :recibos, :column => :titular_id
    remove_index :recibos, :column => [:titular_id, :titular_type]
  end
end
