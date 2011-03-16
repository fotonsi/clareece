DROP VIEW cursos_alumnos;
CREATE VIEW cursos_alumnos AS
select f.id, c.num_colegiado, c.nombre, c.apellido1, c.apellido2, c.doc_identidad, f.estado, f.nota, f.forma_pago, cu.nombre as nombre_curso, cu.num_horas_presenciales, cu.num_horas_virtuales, (cu.num_horas_presenciales+cu.num_horas_virtuales) as num_horas, cu.temario, to_char(cu.fecha_limite_devolucion, 'DD/MM/YYYY') as fecha_limite_devolucion,
	(case when f.estado = 'matriculado' then 'INSCRIPCIÓN' else 'RESERVA' end) as concepto,
	(select to_char(min(ch.fecha_ini), 'DD/MM/YYYY') from curso_horarios as ch join cursos as cu2 on ch.curso_id = cu2.id where cu2.id = cu.id) as fecha_ini,
	(select to_char(max(ch.fecha_fin), 'DD/MM/YYYY') from curso_horarios as ch join cursos as cu2 on ch.curso_id = cu2.id where cu2.id = cu.id) as fecha_fin,
	(select creditos from curso_acreditaciones as ca join entidades_acreditadoras as ea on ca.entidad_acreditadora_id=ea.id where curso_id = cu.id and ea.nombre_alias = 'esscan') as creditos_esscan,
       	(select creditos from curso_acreditaciones as ca join entidades_acreditadoras as ea on ca.entidad_acreditadora_id=ea.id where curso_id = cu.id and ea.nombre_alias = 'consejo_general') as creditos_consejo_general,
       	(select creditos from curso_acreditaciones as ca join entidades_acreditadoras as ea on ca.entidad_acreditadora_id=ea.id where curso_id = cu.id and ea.nombre_alias = 'consejo_internacional') as creditos_consejo_internacional,
	(select id from titulos where formacion_id = f.id order by fecha, created_at desc limit 1) as num_titulo,
	(select fecha from titulos where formacion_id = f.id order by fecha, created_at desc limit 1) as fecha_titulo,
	''::varchar as num_horas_letra,
	(select array_to_string(ARRAY(select to_char(ch.fecha_ini, 'DD/MM/YYYY') || ' al ' || to_char(ch.fecha_fin, 'DD/MM/YYYY') || ' de ' || ch.hora_ini || ' a ' || ch.hora_fin from curso_horarios as ch where ch.curso_id = cu.id order by ch.fecha_ini, ch.fecha_fin, ch.hora_ini, ch.hora_fin), '; ')) as horario,
	cu.precio_matricula,
	l.nombre as lugar_celebracion,
	to_char(f.created_at, 'DD/MM/YYYY') as fecha
from formaciones as f
join colegiados as c on f.alumno_id = c.id and f.alumno_type = 'Colegiado'
join cursos as cu on cu.id = f.curso_id
left join aulas as a on cu.aula_id = a.id
left join localidades as l on a.localidad_id = l.id
;
