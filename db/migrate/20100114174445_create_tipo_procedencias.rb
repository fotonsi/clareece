class CreateTipoProcedencias < ActiveRecord::Migration
  def self.up
    create_table :tipo_procedencias do |t|
      t.string :nombre, :descripcion
      t.timestamps
    end
    #TipoProcedencia.create(:nombre => 'nuevo_ingreso', :descripcion => 'Nuevo ingreso')
    #TipoProcedencia.create(:nombre => 'traslado_expediente', :descripcion => 'Traslado expediente')
  end

  def self.down
    drop_table :tipo_procedencias
  end
end
