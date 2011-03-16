class RemovePersonaResponsableIdFromSedes < ActiveRecord::Migration
  def self.up
    remove_column :sedes, :persona_responsable_id
  end

  def self.down
    add_column :sedes, :persona_responsable_id, :integer
  end
end
