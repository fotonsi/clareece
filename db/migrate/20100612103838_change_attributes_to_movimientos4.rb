class ChangeAttributesToMovimientos4 < ActiveRecord::Migration
  def self.up
    change_column :movimientos, :fecha, :date
    remove_column :movimientos, :saldo_inicial
    remove_column :movimientos, :saldo_final
  end

  def self.down
    add_column :movimientos, :saldo_final, :float
    add_column :movimientos, :saldo_inicial, :float
    change_column :movimientos, :fecha, :datetime
  end
end
