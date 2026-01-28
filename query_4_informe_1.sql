-- INDEX B-TREE
create INDEX  index_est_nom
ON participacion_clase (nombre_estudiante);

create INDEX index_est_nom
ON asistencia (nombre_estudiante,estado);

create INDEX index_est_hora
ON asistencia (hora_llegada);

create INDEX index_est_tip_part
ON participacion_clase (tipo_participacion);

-- creacion de FULL TEXT INDEX 
create FULLTEXT INDEX index_escuela_nombre
ON escuela (nombre_escuela);

create FULLTEXT INDEX index_justificacion_motivo
ON justificacion (motivo);

-- Visualizacion
show INDEX FROM participacion_clase;
show INDEX FROM asistencia;

-- Visualizacion Estadisticas
select *
FROM sys.schema_index_statistics
where table_schema='proyectobdd2'
AND table_name= 'asistencia'
order by rows_selected DESC;

-- CON INDEX
explain analyze
select *
FROM  participacion_clase
WHERE tipo_participacion='Pregunta';

-- SIN INDEX
explain analyze
select *
FROM proyectobdd2.participacion_clase IGNORE INDEX (index_est_tip_part)
WHERE tipo_participacion='Pregunta';



-- select * from justificacion;