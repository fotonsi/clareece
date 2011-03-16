class FormacionApto < ActiveRecord::Migration
  def self.up
    add_column :formaciones, :apto, :boolean, :default => true
  end

  def self.down
    remove_column :formaciones, :apto
  end
end
