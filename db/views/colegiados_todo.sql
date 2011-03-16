DROP VIEW COLEGIADOS_TODO;
CREATE VIEW COLEGIADOS_TODO AS
SELECT c.apellido1, c.apellido2, b.nombre AS banco, c.cc_aa, ce.nombre AS centro, c.cod_postal AS cod_postal, c.cp_titular_cuenta, c.created_at, c.cuota_ingreso_forma_pago, c.destino, c.direccion, c.doc_identidad, c.domiciliar_pagos, c.domicilio_titular_cuenta, c.eboletin, c.ejercicio_profesional, c.email, c.err_migracion, c.exento_pago, c.expediente_id, c.fax, to_char(c.fecha_baja, 'DD-MM-YYYY') as fecha_baja, fecha_baja as fecha_baja_calc, to_char(c.fecha_cambio_domicilio, 'DD-MM-YYYY') as fecha_cambio_domicilio, fecha_cambio_domicilio as fecha_cambio_domicilio_calc, to_char(c.fecha_fin_exencion_pago, 'DD-MM-YYYY') as fecha_fin_exencion_pago, fecha_fin_exencion_pago as fecha_fin_exencion_pago_calc, to_char(c.fecha_ingreso, 'DD-MM-YYYY') as fecha_ingreso, fecha_ingreso as fecha_ingreso_calc, to_char(c.fecha_ini_exencion_pago, 'DD-MM-YYYY') as fecha_ini_exencion_pago, fecha_ini_exencion_pago as fecha_ini_exencion_pago_calc, to_char(c.fecha_nacimiento, 'DD-MM-YYYY') as fecha_nacimiento, fecha_nacimiento as fecha_nacimiento_calc, c.grado_carrera, c.id, c.importe_deuda, c.jubilado, c.localidad, c.localidad_nacimiento, c.migrado, c.motivo_baja_id, c.motivo_ingreso_id, c.no_ejerciente, c.nombre, c.nombre_titular_cuenta, c.num_colegiado, c.num_cuenta, c.observaciones, c.oficina, p.nombre AS pais, c.plaza_domicilio_titular_cuenta, c.poblacion_banco, c.procedencia, pr.nombre AS profesion, c.ref_historial, c.revista, c.saldar_deuda, c.sexo, c.situacion_colegial, c.situacion_profesional, c.sociedad_profesional, c.telefonos, 
case when telefonos ~ E'.*(\\d{9}).*' then regexp_replace(telefonos, E'.*(\\d{9}).*', E'\\1') else null end as telefono_fijo,
case when telefonos ~ E'.*(6\\d{8}).*' then regexp_replace(telefonos, E'.*(6\\d{8}).*', E'\\1') else null end as telefono_movil,
c.telefono_trabajo, c.tipo_doc_identidad, c.titular_cuenta, c.type, c.updated_at
FROM colegiados as c
LEFT JOIN bancos AS b ON c.banco_id = b.id
LEFT JOIN centros AS ce ON c.centro_id = ce.id
LEFT JOIN paises AS p ON c.pais_id = p.id
LEFT JOIN profesiones AS pr ON c.profesion_id = pr.id
;
