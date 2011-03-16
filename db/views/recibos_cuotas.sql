DROP VIEW recibos_cuotas;
CREATE VIEW recibos_cuotas AS
SELECT movimientos.id, nombre, apellido1, apellido2, num_colegiado, abs(importe) as importe, forma_pago, concepto, concepto_de, fecha, (fecha_anulacion is not null) as anulado, ''::varchar AS importe_letra
FROM movimientos
JOIN colegiados ON titular_id = colegiados.id and titular_type='Colegiado'
WHERE importe < 0;
