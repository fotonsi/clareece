class AddAttributesToAdjuntos < ActiveRecord::Migration
  def self.up
    add_column :adjuntos, :type, :string
    add_column :adjuntos, :saved_as, :string
  end

  def self.down
    remove_column :adjuntos, :saved_as
    remove_column :adjuntos, :type
  end
end
