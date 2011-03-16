class AddAttributesToFormaciones < ActiveRecord::Migration
  def self.up
    add_column :formaciones, :forma_pago, :string
  end

  def self.down
    remove_column :formaciones, :forma_pago
  end
end
