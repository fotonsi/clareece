class AddAttributesToMovimientos2 < ActiveRecord::Migration
  def self.up
    add_column :movimientos, :forma_pago, :string
  end

  def self.down
    remove_column :movimientos, :forma_pago
  end
end
