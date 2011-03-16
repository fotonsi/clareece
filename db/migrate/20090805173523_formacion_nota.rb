class FormacionNota < ActiveRecord::Migration
  def self.up
    add_column :formaciones, :nota, :float
  end

  def self.down
    remove_column :formaciones, :nota
  end
end
