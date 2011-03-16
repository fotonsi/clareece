class RemovePersonaResponsableIdFromEmpresas < ActiveRecord::Migration
  def self.up
    remove_column :empresas, :persona_responsable_id
  end

  def self.down
    add_column :empresas, :persona_responsable_id, :integer
  end
end
