class AddAttributesToColegiados4 < ActiveRecord::Migration
  def self.up
    add_column :colegiados, :expediente_id, :integer
  end

  def self.down
    remove_column :colegiados, :expediente_id
  end
end
