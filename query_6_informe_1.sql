-- CON INDEX
explain analyze
select *
FROM  participacion_clase
WHERE tipo_participacion='Pregunta';

-- SIN INDEX
explain analyze
select *
FROM  NuevoEsquema.participacion_clase IGNORE INDEX (index_est_tip_part)
WHERE tipo_participacion='Pregunta';

-- CON INDEX
explain analyze
select *
FROM  asistencia
WHERE estado='Presente';

-- SIN INDEX
explain analyze
select *
FROM  NuevoEsquema.asistencia IGNORE INDEX (index_est_nom)
WHERE estado='Presente';

-- CON INDEX 
explain analyze
select *
FROM  participacion_clase
WHERE id_estudiante=1723;

-- SIN INDEX 
explain analyze
select *
FROM  NuevoEsquema.participacion_clase IGNORE INDEX (index_est_nom)
WHERE id_estudiante=1723;

-- CON INDEX 
explain analyze
select *
FROM  asistencia
WHERE hora_llegada>='08:39:31';

explain analyze
select *
FROM  NuevoEsquema.asistencia IGNORE INDEX (index_est_hora)
WHERE hora_llegada>='08:39:31';


-- CON INDEX 
explain analyze
SELECT * FROM escuela 
WHERE MATCH(nombre_escuela) AGAINST('Instituto' IN BOOLEAN MODE);

-- SIN INDEX 
explain analyze
select *
FROM  NuevoEsquema.escuela IGNORE INDEX (index_escuela_nombre)
WHERE nombre_escuela LIKE'%Instituto%';

-- CON INDEX 
explain analyze
select *
FROM  justificacion
WHERE motivo LIKE '%Problema%';

-- SIN INDEX 
explain analyze
select *
FROM  NuevoEsquema.escuela IGNORE INDEX (index_justificacion_motivo)
WHERE motivo LIKE '%Problema%';

-- QUERY EXTRAS 
-- CON INDEX
EXPLAIN ANALYZE 
SELECT * 
FROM participacion_clase 
WHERE puntos_puntuacion = 16;

-- SIN INDEX 
EXPLAIN ANALYZE 
SELECT * 
FROM participacion_clase IGNORE INDEX (idx_btree_participacion_puntos)
WHERE puntos_puntuacion = 16;

-- CON INDEX
EXPLAIN ANALYZE 
SELECT * 
FROM incidencia 
WHERE MATCH(descripcion) AGAINST('medico fiebre salud' IN NATURAL LANGUAGE MODE);

-- SIN INDEX
EXPLAIN ANALYZE 
SELECT * 
FROM incidencia 
WHERE descripcion LIKE '%medico%' OR descripcion LIKE '%fiebre%' OR descripcion LIKE '%salud%';

-- CON INDEX
EXPLAIN ANALYZE 
SELECT * 
FROM sesion_clase 
WHERE MATCH(tema) AGAINST('programacion algoritmos' IN NATURAL LANGUAGE MODE);

-- SIN INDEX
EXPLAIN ANALYZE 
SELECT * 
FROM sesion_clase IGNORE INDEX (idx_ft_sesion_tema)
WHERE tema LIKE '%programacion%' OR tema LIKE '%algoritmos%';




