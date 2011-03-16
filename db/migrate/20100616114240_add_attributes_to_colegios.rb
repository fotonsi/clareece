class AddAttributesToColegios < ActiveRecord::Migration
  def self.up
    add_column :colegios, :contabilidad_email, :string
  end

  def self.down
    remove_column :colegios, :contabilidad_email
  end
end
