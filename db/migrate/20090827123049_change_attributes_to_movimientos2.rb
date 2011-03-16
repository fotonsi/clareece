class ChangeAttributesToMovimientos2 < ActiveRecord::Migration
  def self.up
    add_column :movimientos, :concepto_de, :string
    remove_column :movimientos, :saldo_inicial_caja
    remove_column :movimientos, :saldo_inicial_trans
    remove_column :movimientos, :saldo_inicial_cursos
    remove_column :movimientos, :saldo_final_caja
    remove_column :movimientos, :saldo_final_trans
    remove_column :movimientos, :saldo_final_cursos
  end

  def self.down
    add_column :movimientos, :saldo_final_cursos, :float
    add_column :movimientos, :saldo_final_trans, :float
    add_column :movimientos, :saldo_final_caja, :float
    add_column :movimientos, :saldo_inicial_cursos, :float
    add_column :movimientos, :saldo_inicial_trans, :float
    add_column :movimientos, :saldo_inicial_caja, :float
    remove_column :movimientos, :concepto_de
  end
end
