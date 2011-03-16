DROP VIEW libramientos;
CREATE VIEW libramientos AS
SELECT id, caja_id, abs(importe) as importe, titular_id, titular_type, forma_pago, concepto_de, fecha, a_favor_de,
	(fecha_anulacion is not null) as anulado, concepto, ''::varchar AS importe_letra
FROM movimientos WHERE importe > 0;
