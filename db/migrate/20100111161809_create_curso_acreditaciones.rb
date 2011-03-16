class CreateCursoAcreditaciones < ActiveRecord::Migration
  def self.up
    create_table :curso_acreditaciones do |t|
      t.integer :entidad_acreditadora_id, :curso_id
      t.float :creditos
      t.date :fecha_solicitud, :fecha_obtencion
      t.string :codigo
      t.timestamps
    end
  end

  def self.down
    drop_table :curso_acreditaciones
  end
end
