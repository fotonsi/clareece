class ColegiadoTelefonosJuntos < ActiveRecord::Migration
  def self.up
    Colegiado.all.each {|c| c.telefono1 = [c.telefono1, c.telefono2].join(","); c.save! }
    remove_column :colegiados, :telefono2
    rename_column :colegiados, :telefono1, :telefonos
  end

  def self.down
    rename_column :colegiados, :telefonos, :telefono1
    add_column :colegiados, :telefono2, :string
    Colegiado.all.each {|c| c.telefono1, c.telefono2 = c.telefonos.split(","); c.save! }
  end
end
