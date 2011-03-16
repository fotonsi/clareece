DROP VIEW recibos_generico;
CREATE VIEW recibos_generico AS
SELECT movimientos.id,
CASE WHEN titular_type = 'Colegiado' THEN nombre || ' ' || apellido1 || ' ' || apellido2 || ' (#' || num_colegiado || ')' ELSE a_favor_de END as recibido_de,
abs(importe) as importe, forma_pago, concepto, concepto_de, fecha, (fecha_anulacion is not null) as anulado, ''::varchar AS importe_letra
FROM movimientos
LEFT JOIN colegiados ON titular_id = colegiados.id and titular_type='Colegiado'
WHERE importe < 0;
