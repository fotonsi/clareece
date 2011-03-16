class ReciboTitular < ActiveRecord::Migration
  def self.up
    add_column :recibos, :titular_id, :integer
    add_column :recibos, :titular_type, :string
  end

  def self.down
    remove_column :recibos, :titular_type
    remove_column :recibos, :titular_id
  end
end
