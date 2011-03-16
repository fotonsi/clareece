class RemesaFicheroBancarioId < ActiveRecord::Migration
  def self.up
    add_column :remesas, :fichero_bancario_id, :integer
  end

  def self.down
    remove_column :remesas, :fichero_bancario_id
  end
end
