DROP VIEW diplomas;
CREATE VIEW diplomas AS
select f.id, c.num_colegiado, c.nombre, c.apellido1, c.apellido2, c.doc_identidad, f.estado, f.nota, f.forma_pago, cu.nombre as nombre_curso, cu.num_horas_presenciales, cu.num_horas_virtuales, (cu.num_horas_presenciales+cu.num_horas_virtuales) as num_horas, cu.temario,
	(select min(ch.fecha_ini) from curso_horarios as ch join cursos as cu2 on ch.curso_id = cu2.id where cu2.id = cu.id) as fecha_ini,
	(select max(ch.fecha_fin) from curso_horarios as ch join cursos as cu2 on ch.curso_id = cu2.id where cu2.id = cu.id) as fecha_fin,
	(select creditos from curso_acreditaciones as ca join entidades_acreditadoras as ea on ca.entidad_acreditadora_id=ea.id where curso_id = cu.id and ea.nombre_alias = 'esscan') as creditos_esscan,
       	(select creditos from curso_acreditaciones as ca join entidades_acreditadoras as ea on ca.entidad_acreditadora_id=ea.id where curso_id = cu.id and ea.nombre_alias = 'consejo_general') as creditos_consejo_general,
       	(select creditos from curso_acreditaciones as ca join entidades_acreditadoras as ea on ca.entidad_acreditadora_id=ea.id where curso_id = cu.id and ea.nombre_alias = 'consejo_internacional') as creditos_consejo_internacional,
	(select id from titulos where formacion_id = f.id order by fecha, created_at desc limit 1) as num_titulo,
	(select fecha from titulos where formacion_id = f.id order by fecha, created_at desc limit 1) as fecha_titulo,
	''::varchar as num_horas_letra
from formaciones as f
join colegiados as c on f.alumno_id = c.id and f.alumno_type = 'Colegiado'
join cursos as cu on cu.id = f.curso_id
;
