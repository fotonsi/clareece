OBJETO_PRINCIPAL="colegiado"
DATOS_OBJETO_PRINCIPAL={
  :ESTADOS => [:colegiado, :colegiado_no_ejerciente, :baja_colegial],
  :ESTADO_ACTIVO => :colegiado,
  :ESTADO_BAJA => :baja_colegial,
  :ESTADO_EXENTO => :colegiado_no_ejerciente,
  :EJERCICIOS_PROFESIONALES => {
    'AUTONOMO' => 'Autónomo',
    'CUENTA_AJENA_PUBLICO_SS' => 'Cta. ajena público - Servicio Salud',
    'CUENTA_AJENA_PUBLICO_OTRAS_ADMS' => 'Cta. ajena público - Otras adms.',
    'CUENTA_AJENA_PRIVADO' => 'Cta. ajena privado',
    'CUENTA_AJENA_CONCERTADO' => 'Cta. ajena concertado'
  },
  :SITUACIONES_PROFESIONALES => {
    'NO_ACTIVO_DESEMPLEO' => 'No activo - Desempleado',
    'NO_ACTIVO_OTRAS' => 'No activo - Otras situaciones adms.',
    'NO_ACTIVO_JUBILADO' => 'No activo - Jubilado',
    'ACTIVO_FIJO' => 'Activo - Fijo',
    'ACTIVO_TEMPORAL' => 'Activo - Temporal'
  },
  :GRADOS_CARRERA => {
    'GRADO1' => 'Grado 1',
    'GRADO2' => 'Grado 2',
    'GRADO3' => 'Grado 3',
    'GRADO4' => 'Grado 4',
  }
}
TIPOS_EXPEDIENTES = [OBJETO_PRINCIPAL, :otro]
ETIQUETAS_OBLIGATORIAS = [
    { :cond => Proc.new {|col| col.sociedad_profesional && col.situacion_colegial.to_sym == DATOS_OBJETO_PRINCIPAL[:ESTADO_ACTIVO]},
      :etiqs => [:inscripcion_registro_mercantil] },
    { :cond => Proc.new {|col| col.situacion_colegial.to_sym == DATOS_OBJETO_PRINCIPAL[:ESTADO_ACTIVO]},
      :etiqs => [:solicitud_alta, :documento_identidad, :titulo_profesional] },
    { :cond => Proc.new {|col| col.motivo_baja && TipoDestino::BAJAS_SOLICITADAS.include?(col.motivo_baja.nombre.to_sym) && col.situacion_colegial.to_sym == DATOS_OBJETO_PRINCIPAL[:ESTADO_BAJA] },
      :etiqs => [:solicitud_baja] },
    { :cond => Proc.new {|col| col.motivo_baja && TipoDestino::BAJAS_RESOLUCION_COLEGIAL.include?(col.motivo_baja.nombre.to_sym) && col.situacion_colegial.to_sym == DATOS_OBJETO_PRINCIPAL[:ESTADO_BAJA] },
      :etiqs => [:resolucion_baja] },
    { :cond => Proc.new {|col| col.motivo_baja && TipoDestino::BAJAS_SOLICITADAS.include?(col.motivo_baja.nombre.to_sym) && col.situacion_colegial.to_sym == DATOS_OBJETO_PRINCIPAL[:ESTADO_EXENTO] },
      :etiqs => [:solicitud_no_ejerciente] },
    { :cond => Proc.new {|col| col.motivo_baja && TipoDestino::BAJAS_RESOLUCION_COLEGIAL.include?(col.motivo_baja.nombre.to_sym) && col.situacion_colegial.to_sym == DATOS_OBJETO_PRINCIPAL[:ESTADO_EXENTO] },
      :etiqs => [:resolucion_no_ejerciente] },
]
ETIQUETAS_OPTATIVAS = [
    { :cond => Proc.new {|col| !col.sociedad_profesional? && col.situacion_colegial.to_sym == DATOS_OBJETO_PRINCIPAL[:ESTADO_ACTIVO] && (!col.migrado && col.motivo_ingreso != TipoProcedencia.find_by_nombre('nuevo_ingreso') || !Movimiento::FORMAS_PAGO_CAJA.include?(col.cuota_ingreso_forma_pago.to_sym))},
      :etiqs => [:foto_documento_identidad, :certificado_nacimiento_literal] },
    { :cond => Proc.new {|col| !col.sociedad_profesional? && col.domiciliar_pagos && col.situacion_colegial.to_sym == DATOS_OBJETO_PRINCIPAL[:ESTADO_ACTIVO]},
      :etiqs => [:foto_documento_identidad, :certificado_nacimiento_literal, :recibo_cuota_ingreso, :autorizacion_domiciliacion] },
    { :cond => Proc.new {|col| !col.sociedad_profesional? && col.situacion_colegial.to_sym == DATOS_OBJETO_PRINCIPAL[:ESTADO_ACTIVO]},
      :etiqs => [:foto_documento_identidad, :certificado_nacimiento_literal, :recibo_cuota_ingreso] },
]
TIPOS_EXPEDIENTES = [OBJETO_PRINCIPAL, :otro]
DATOS_MOVIMIENTOS = {
    :CONCEPTOS => [:cuota_colegiacion, :curso, :otro],
    :CONCEPTO_CUOTA_PERIODICA => :cuota_colegiacion,
}
