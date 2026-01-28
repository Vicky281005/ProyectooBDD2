-- 1 SEDE
SELECT 
    4 AS id_sede_int, 
    (SELECT ROUND(AVG(LENGTH(nombre_sede))) FROM sede) AS nombre_sede_str,
    (SELECT ROUND(AVG(LENGTH(region))) FROM sede) AS region_str,
    (4 + (SELECT ROUND(AVG(LENGTH(nombre_sede))) FROM sede) + (SELECT ROUND(AVG(LENGTH(region))) FROM sede)) AS calculos_manuales
FROM (SELECT 1) AS d;

-- 2 FACULTAD
SELECT 
    4 AS id_facultad_int, 
    4 AS id_sede_int,
    (SELECT ROUND(AVG(LENGTH(nombre_facultad))) FROM facultad) AS nombre_facultad_str,
    (4 + 4 + (SELECT ROUND(AVG(LENGTH(nombre_facultad))) FROM facultad)) AS calculos_manuales
FROM (SELECT 1) AS d;

-- 3 ESCUELA
SELECT 
    4 AS id_escuela_int, 
    4 AS id_facultad_int,
    (SELECT ROUND(AVG(LENGTH(nombre_escuela))) FROM escuela) AS nombre_escuela_str,
    (4 + 4 + (SELECT ROUND(AVG(LENGTH(nombre_escuela))) FROM escuela)) AS calculos_manuales
FROM (SELECT 1) AS d;


-- 4 SESION_CLASE
SELECT 
    4 AS id_sesion_int, 
    4 AS id_escuela_int,
    3 AS fecha_sesion_date, 
    3 AS hora_inicio_time,  
    3 AS hora_fin_time,
    (SELECT ROUND(AVG(LENGTH(tema))) FROM sesion_clase) AS tema_str,
    (4 + 4 + 3 + 3 + 3 + (SELECT ROUND(AVG(LENGTH(tema))) FROM sesion_clase)) AS calculos_manuales
FROM (SELECT 1) AS d;


-- 5 ASISTENCIA
SELECT 
    4 AS id_asistencia_int,
    4 AS id_sesion_int,
    4 AS id_estudiante_int,
    (SELECT ROUND(AVG(LENGTH(estado))) FROM asistencia) AS estado_str,
    3 AS hora_llegada_time,
    (
        4 + 4 + 4 +
        (SELECT ROUND(AVG(LENGTH(estado))) FROM asistencia) +
        3
    ) AS calculos_manuales
FROM (SELECT 1) AS d;

-- 6 JUSTIFICACION
SELECT 
    4 AS id_justificacion_int, 
    4 AS id_asistencia_int,
    (SELECT ROUND(AVG(LENGTH(motivo))) FROM justificacion) AS motivo_str,
    (4 + 4 + (SELECT ROUND(AVG(LENGTH(motivo))) FROM justificacion)) AS calculos_manuales
FROM (SELECT 1) AS d;

-- 7 INCIDENCIA
SELECT 
    4 AS id_incidencia_int,
    4 AS id_sesion_int,
    4 AS id_estudiante_int,
    (SELECT ROUND(AVG(LENGTH(descripcion))) FROM incidencia) AS descripcion_str,
    (4 + 4 + 4 +(SELECT ROUND(AVG(LENGTH(descripcion))) FROM incidencia)
    ) AS calculos_manuales
FROM (SELECT 1) AS d;

-- 8 PARTICIPACION_CLASE
SELECT 
    4 AS id_participacion_int,
    4 AS id_sesion_int,
    4 AS id_estudiante_int,
    (SELECT ROUND(AVG(LENGTH(tipo_participacion))) FROM participacion_clase) AS tipo_part_str,
    4 AS puntos_puntuacion_int,
    (SELECT ROUND(AVG(LENGTH(comentario))) FROM participacion_clase) AS comentario_str,
    (4 + 4 + 4 +(SELECT ROUND(AVG(LENGTH(tipo_participacion))) FROM participacion_clase) +
        4 +(SELECT ROUND(AVG(LENGTH(comentario))) FROM participacion_clase)
    ) AS calculos_manuales
FROM (SELECT 1) AS d;

-- 9 ESTUDIANTE
SELECT 
    4 AS id_estudiante_int,
    (SELECT ROUND(AVG(LENGTH(nombre))) FROM estudiante) AS nombre_str,
    (SELECT ROUND(AVG(LENGTH(apellido))) FROM estudiante) AS apellido_str,
    3 AS fecha_registro_date,
    4 AS id_escuela_int,
    (4 +
        (SELECT ROUND(AVG(LENGTH(nombre))) FROM estudiante) +
        (SELECT ROUND(AVG(LENGTH(apellido))) FROM estudiante)+
        3 + 4
    ) AS calculos_manuales
FROM (SELECT 1) AS d;

-- Query completo (no manual)
SELECT 
    Tabla,
    avg_row_length,
    factor_bloqueo_fb,
    total_filas,
    CEILING(total_filas / factor_bloqueo_fb) AS cantidad_paginas_T

FROM (
    SELECT 
        table_name AS Tabla,
        IFNULL(avg_row_length, 0) AS avg_row_length,
        
        -- Cálculo del Factor de Bloqueo (FB)
        FLOOR((16384 - 154) / (IFNULL(avg_row_length, 0) + 13)) AS factor_bloqueo_fb,
        
        IFNULL(table_rows, 0) AS total_filas
    FROM information_schema.tables 
    WHERE table_schema = DATABASE() 
      AND table_name IN ('sede', 'facultad', 'escuela', 'sesion_clase', 'asistencia', 'justificacion', 'incidencia', 'participacion_clase','estudiante')
) AS datos_base;



