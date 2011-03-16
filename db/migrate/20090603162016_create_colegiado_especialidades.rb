class CreateColegiadoEspecialidades < ActiveRecord::Migration
  def self.up
    create_table :colegiado_especialidades do |t|
      t.integer :colegiado_id, :especialidad_id
      t.timestamps
    end
  end

  def self.down
    drop_table :colegiado_especialidades
  end
end
