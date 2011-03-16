class TipoDestino < ActiveRecord::Base
  has_many :colegiados, :foreign_key => 'motivo_destino_id'

  BAJAS_SOLICITADAS = [:baja, :baja_temporal, :baja_voluntaria, :cese_en_el_ejercicio, :traslado_de_expediente, :peticion_propia]
  BAJAS_RESOLUCION_COLEGIAL = [:falta_de_pago, :orden_comision_ejecutiva, :orden_junta_gobierno]

  def to_label
    self.descripcion
  end
end
