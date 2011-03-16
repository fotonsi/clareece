class CreateTipoDestinos < ActiveRecord::Migration
  def self.up
    create_table :tipo_destinos do |t|
      t.string :nombre, :descripcion
      t.timestamps
    end
    #TipoDestino.create(:nombre => 'traslado_expediente', :descripcion => 'Traslado expediente')
  end

  def self.down
    drop_table :tipo_destinos
  end
end
