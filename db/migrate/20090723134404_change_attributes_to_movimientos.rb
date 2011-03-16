class ChangeAttributesToMovimientos < ActiveRecord::Migration
  def self.up
    remove_column :movimientos, :pagador_id
    remove_column :movimientos, :pagador_type
    add_column :movimientos, :titular_id, :integer
    add_column :movimientos, :titular_type, :string
    add_column :movimientos, :origen_id, :integer
    add_column :movimientos, :origen_type, :string
    add_column :movimientos, :concepto, :string
    add_column :movimientos, :tipo, :string
    add_column :movimientos, :saldo_inicial, :float
    add_column :movimientos, :saldo_final, :float
    add_column :movimientos, :devuelto, :boolean, :default => false
  end

  def self.down
    remove_column :movimientos, :devuelto
    remove_column :movimientos, :saldo_final
    remove_column :movimientos, :saldo_inicial
    remove_column :movimientos, :tipo
    remove_column :movimientos, :concepto
    remove_column :movimientos, :origen_type
    remove_column :movimientos, :origen_id
    remove_column :movimientos, :titular_type
    remove_column :movimientos, :titular_id
    add_column :movimientos, :pagador_type, :string
    add_column :movimientos, :pagador_id, :integer
  end
end
