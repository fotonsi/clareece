class AddAttributesToRecibos < ActiveRecord::Migration
  def self.up
    add_column :recibos, :estado, :string
  end

  def self.down
    remove_column :recibos, :estado
  end
end
