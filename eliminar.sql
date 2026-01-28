-- NIVEL 7: Tablas finales
DROP TABLE IF EXISTS justificacion;
DROP TABLE IF EXISTS participacion_clase;
DROP TABLE IF EXISTS incidencia;

-- NIVEL 6: Depende de Sesión y Estudiante
DROP TABLE IF EXISTS asistencia;

-- NIVEL 5: Depende de Escuela
DROP TABLE IF EXISTS sesion_clase;
DROP TABLE IF EXISTS estudiante;

-- NIVEL 4: Depende de Facultad
DROP TABLE IF EXISTS escuela;

-- NIVEL 3: Depende de Sede
DROP TABLE IF EXISTS facultad;

-- NIVEL 2: Base
DROP TABLE IF EXISTS sede;







-- 1. APAGAMOS LA SEGURIDAD (Para poder borrar en el orden que pediste)
SET FOREIGN_KEY_CHECKS = 0;

-- NIVEL 1: Base
TRUNCATE TABLE sede;

-- NIVEL 2
TRUNCATE TABLE facultad;

-- NIVEL 3
TRUNCATE TABLE escuela;

-- NIVEL 4
TRUNCATE TABLE estudiante;
TRUNCATE TABLE sesion_clase;

-- NIVEL 5
TRUNCATE TABLE asistencia;

-- NIVEL 6
TRUNCATE TABLE justificacion;
TRUNCATE TABLE participacion_clase;
TRUNCATE TABLE incidencia;


-- 3. ENCENDEMOS LA SEGURIDAD
SET FOREIGN_KEY_CHECKS = 1;

-- 4. GENERAR LOS DATOS (Ahora sí coincidirán los IDs)
CALL CargarTodoMasivo();