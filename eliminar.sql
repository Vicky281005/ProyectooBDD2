-- NIVEL 6: Tablas finales
DROP TABLE IF EXISTS justificacion;
DROP TABLE IF EXISTS incidencia;
DROP TABLE IF EXISTS participacion_clase;

-- NIVEL 5: Depende de Sesión/Asistencia
DROP TABLE IF EXISTS asistencia;

-- NIVEL 4: Depende de Escuela
DROP TABLE IF EXISTS sesion_clase;

-- NIVEL 3: Depende de Facultad
DROP TABLE IF EXISTS escuela;

-- NIVEL 2: Depende de Sede
DROP TABLE IF EXISTS facultad;

-- NIVEL 1: La base
DROP TABLE IF EXISTS sede;






-- 1. APAGAMOS LA SEGURIDAD (Para poder borrar en el orden que pediste)
SET FOREIGN_KEY_CHECKS = 0; 

-- 2. LIMPIEZA POR JERARQUÍA (Reinicio de IDs a 1)
-- Nivel 1: La base
TRUNCATE TABLE sede;

-- Nivel 2: Depende de Sede
TRUNCATE TABLE facultad;

-- Nivel 3: Depende de Facultad
TRUNCATE TABLE escuela;

-- Nivel 4: Depende de Escuela
TRUNCATE TABLE sesion_clase;

-- Nivel 5: Depende de Sesión
TRUNCATE TABLE asistencia;

-- Nivel 6: Tablas finales (Dependen de Asistencia o Sesión)
TRUNCATE TABLE justificacion;
TRUNCATE TABLE incidencia;
TRUNCATE TABLE participacion_clase;

-- 3. ENCENDEMOS LA SEGURIDAD
SET FOREIGN_KEY_CHECKS = 1;

-- 4. GENERAR LOS DATOS (Ahora sí coincidirán los IDs)
CALL CargarTodoMasivo();