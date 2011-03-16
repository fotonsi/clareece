class AddAttributesToMovimientos < ActiveRecord::Migration
  def self.up
    add_column :movimientos, :saldo_inicial_caja, :float
    add_column :movimientos, :saldo_inicial_trans, :float
    add_column :movimientos, :saldo_inicial_cursos, :float
    add_column :movimientos, :saldo_final_caja, :float
    add_column :movimientos, :saldo_final_trans, :float
    add_column :movimientos, :saldo_final_cursos, :float
    remove_column :movimientos, :activo
    add_column :movimientos, :activo, :boolean
  end

  def self.down
    remove_column :movimientos, :activo
    add_column :movimientos, :activo, :default => false
    remove_column :movimientos, :saldo_final_cursos
    remove_column :movimientos, :saldo_final_trans
    remove_column :movimientos, :saldo_final_caja
    remove_column :movimientos, :saldo_inicial_cursos
    remove_column :movimientos, :saldo_inicial_trans
    remove_column :movimientos, :saldo_inicial_caja
  end
end
