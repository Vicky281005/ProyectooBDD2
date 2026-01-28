-- INDEX B-TREE
create INDEX  index_est_nom
ON participacion_clase (id_estudiante);

create INDEX index_est_nom
ON asistencia (id_estudiante,estado);

create INDEX index_est_hora
ON asistencia (hora_llegada);

create INDEX index_est_tip_part
ON participacion_clase (tipo_participacion);

-- creacion de FULL TEXT INDEX 
create FULLTEXT INDEX index_escuela_nombre
ON escuela (nombre_escuela);

create FULLTEXT INDEX index_justificacion_motivo
ON justificacion (motivo);


-- indices extras
CREATE FULLTEXT INDEX idx_ft_sesion_tema 
ON sesion_clase(tema);

CREATE FULLTEXT INDEX idx_ft_incidencia_desc 
ON incidencia(descripcion);

CREATE INDEX idx_btree_participacion_puntos 
ON participacion_clase(puntos_puntuacion);











-- Visualizacion Estadisticas
select *
FROM sys.schema_index_statistics
where table_schema='NuevoEsquema'
AND table_name= 'asistencia'
order by rows_selected DESC;



-- select * from justificacion;