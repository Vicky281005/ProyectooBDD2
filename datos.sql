-- ==========================================================
-- 1. LIMPIEZA TOTAL (Reset de IDs)
-- ==========================================================
SET FOREIGN_KEY_CHECKS = 0;

TRUNCATE TABLE participacion_clase;
TRUNCATE TABLE incidencia;
TRUNCATE TABLE justificacion;
TRUNCATE TABLE asistencia;
TRUNCATE TABLE sesion_clase;
truncate table estudiante;
TRUNCATE TABLE escuela;
TRUNCATE TABLE facultad;
TRUNCATE TABLE sede;


SET FOREIGN_KEY_CHECKS = 1;


DELIMITER $$

-- 1. Procedimiento para SEDES (20 registros)
DROP PROCEDURE IF EXISTS PoblarSedes$$
CREATE PROCEDURE PoblarSedes()
BEGIN
    DECLARE i INT DEFAULT 1;
    WHILE i <= 20 DO
        INSERT INTO sede (nombre_sede, region) 
        VALUES (CONCAT('Sede ', i), ELT(FLOOR(1 + RAND() * 3), 'Norte', 'Centro', 'Sur'));
        SET i = i + 1;
    END WHILE;
END$$

-- 2. Procedimiento para FACULTADES (60 registros)
DROP PROCEDURE IF EXISTS PoblarFacultades$$
CREATE PROCEDURE PoblarFacultades()
BEGIN
    DECLARE i INT DEFAULT 1;
    WHILE i <= 60 DO
        INSERT INTO facultad (nombre_facultad, id_sede) 
        VALUES (CONCAT('Facultad ', i), FLOOR(1 + RAND() * 20)); -- Random Sede 1-20
        SET i = i + 1;
    END WHILE;
END$$

-- 3. Procedimiento para ESCUELAS (100 registros)
DROP PROCEDURE IF EXISTS PoblarEscuelas$$
CREATE PROCEDURE PoblarEscuelas()
BEGIN
    DECLARE i INT DEFAULT 1;
    WHILE i <= 100 DO
        INSERT INTO escuela (nombre_escuela, id_facultad) 
        VALUES (CONCAT('Escuela ', i), FLOOR(1 + RAND() * 60)); -- Random Facultad 1-60
        SET i = i + 1;
    END WHILE;
END$$

-- 4. Procedimiento para ESTUDIANTES (3000 registros)
DROP PROCEDURE IF EXISTS PoblarEstudiantes$$
CREATE PROCEDURE PoblarEstudiantes()
BEGIN
    DECLARE i INT DEFAULT 1;
    DECLARE rand_escuela INT;
    
    WHILE i <= 3000 DO
        SET rand_escuela = FLOOR(1 + RAND() * 100); -- Random Escuela 1-100
        INSERT INTO estudiante (nombre, apellido, fecha_registro, id_escuela)
        VALUES (
            ELT(FLOOR(1 + RAND() * 10), 'Juan', 'Ana', 'Pedro', 'Maria', 'Luis', 'Sofia', 'Carlos', 'Lucia', 'Jose', 'Paula'),
            ELT(FLOOR(1 + RAND() * 10), 'Garcia', 'Perez', 'Lopez', 'Gomez', 'Rodriguez', 'Hernandez', 'Martinez', 'Sanchez', 'Diaz', 'Torres'),
            DATE_SUB(CURRENT_DATE, INTERVAL FLOOR(RAND() * 365) DAY), 
            rand_escuela
        );
        SET i = i + 1;
    END WHILE;
END$$

-- 5. Procedimiento para SESIONES DE CLASE (1000 registros)
DROP PROCEDURE IF EXISTS PoblarSesiones$$
CREATE PROCEDURE PoblarSesiones()
BEGIN
    DECLARE i INT DEFAULT 1;
    WHILE i <= 1000 DO
        INSERT INTO sesion_clase (id_escuela, fecha_sesion, hora_inicio, hora_fin, tema) 
        VALUES (
            FLOOR(1 + RAND() * 100), -- Random Escuela 1-100
            DATE_ADD('2025-01-01', INTERVAL FLOOR(RAND() * 180) DAY),
            '08:00:00', 
            '10:00:00', 
            CONCAT('Tema de clase ', i)
        );
        SET i = i + 1;
    END WHILE;
END$$

-- 6. Procedimiento para ASISTENCIA (3000 registros)
-- Estrategia: Recorremos los 3000 estudiantes y le asignamos a cada uno UNA sesión aleatoria.
DROP PROCEDURE IF EXISTS PoblarAsistencias$$
CREATE PROCEDURE PoblarAsistencias()
BEGIN
    DECLARE i INT DEFAULT 1; -- Representará el ID del estudiante (ya que creamos 3000)
    DECLARE rand_estado VARCHAR(20);
    DECLARE rand_sesion INT;

    WHILE i <= 3000 DO
        SET rand_sesion = FLOOR(1 + RAND() * 1000); -- Random Sesión 1-1000
        -- Generar estado aleatorio con probabilidades
        -- 60% Presente, 20% Ausente, 10% Tarde, 10% Justificado
        SET rand_estado = ELT(FLOOR(1 + RAND() * 10), 
            'Presente', 'Presente', 'Presente', 'Presente', 'Presente', 'Presente', -- 60%
            'Ausente', 'Ausente', -- 20%
            'Tarde', -- 10%
            'Justificado'); -- 10%

        -- Insertamos. Usamos IGNORE por si acaso el RAND genera un par duplicado (aunque iterando por ID estudiante es difícil que pase si es 1 a 1)
        INSERT IGNORE INTO asistencia (id_sesion, id_estudiante, estado, hora_llegada)
        VALUES (rand_sesion, i, rand_estado, '08:05:00');
        
        SET i = i + 1;
    END WHILE;
END$$

-- 7. Procedimiento final: JUSTIFICACIONES e INCIDENCIAS y EJECUTOR
DROP PROCEDURE IF EXISTS PoblarBaseDeDatosCompleta$$
CREATE PROCEDURE PoblarBaseDeDatosCompleta()
BEGIN
    -- 1. Ejecutar llenado base
    CALL PoblarSedes();
    CALL PoblarFacultades();
    CALL PoblarEscuelas();
    CALL PoblarEstudiantes();
    CALL PoblarSesiones();
    CALL PoblarAsistencias();

    -- 2. Llenar JUSTIFICACION
    -- "crees para cada estudiante que este inasistente"
    -- Insertamos justificación para todos los que tengan estado 'Ausente' o 'Justificado'
    INSERT INTO justificacion (id_asistencia, motivo)
    SELECT id_asistencia, 'El estudiante presentó certificado médico o excusa válida.'
    FROM asistencia 
    WHERE estado IN ('Ausente', 'Justificado');

    -- 3. Llenar INCIDENCIA
    -- "por cada estudiante que falte y tenga motivos"
    -- Interpretación: Generamos incidencias para los estudiantes ausentes
    INSERT INTO incidencia (id_sesion, id_estudiante, descripcion)
    SELECT id_sesion, id_estudiante, 'El estudiante faltó y se reportó una incidencia académica.'
    FROM asistencia
    WHERE estado = 'Ausente';

END$$

DELIMITER ;

CALL PoblarBaseDeDatosCompleta();

SELECT 'Sedes' AS Tabla, COUNT(*) AS Cantidad FROM sede
UNION
SELECT 'Facultades', COUNT(*) FROM facultad
UNION
SELECT 'Escuelas', COUNT(*) FROM escuela
UNION
SELECT 'Estudiantes', COUNT(*) FROM estudiante
UNION
SELECT 'Sesiones', COUNT(*) FROM sesion_clase
UNION
SELECT 'Asistencias', COUNT(*) FROM asistencia
UNION
SELECT 'Justificaciones', COUNT(*) FROM justificacion
UNION
SELECT 'Incidencias', COUNT(*) FROM incidencia;

SET SQL_SAFE_UPDATES = 0; -- Desactivar protección para permitir updates masivos

-- 1. Corregir AUSENTE y JUSTIFICADO (No deberían tener hora de llegada)
UPDATE asistencia 
SET hora_llegada = NULL 
WHERE estado IN ('Ausente', 'Justificado');

-- 2. Corregir TARDE (Llegan entre 20 y 40 minutos tarde)
-- Se genera una hora aleatoria entre 08:20 y 08:40
UPDATE asistencia 
SET hora_llegada = ADDTIME('08:00:00', SEC_TO_TIME(FLOOR(1200 + RAND() * 1200)))
WHERE estado = 'Tarde';

-- 3. Variar ligeramente a los PRESENTE (Para que no todos lleguen exacto)
-- Se genera una hora aleatoria entre 07:55 y 08:05 (llegaron a tiempo)
UPDATE asistencia 
SET hora_llegada = ADDTIME('07:55:00', SEC_TO_TIME(FLOOR(RAND() * 600)))
WHERE estado = 'Presente';

SET SQL_SAFE_UPDATES = 1; -- Volver a activar protección





DELIMITER $$

DROP PROCEDURE IF EXISTS ActualizarNombresEscuelasRealistas$$
CREATE PROCEDURE ActualizarNombresEscuelasRealistas()
BEGIN
    DECLARE i INT DEFAULT 1;
    DECLARE nuevo_nombre VARCHAR(100);
    
    -- Recorremos las 100 escuelas (IDs del 1 al 100)
    WHILE i <= 100 DO
        -- Generamos un nombre combinando un Prefijo + Un Nombre
        SET nuevo_nombre = CONCAT(
            ELT(FLOOR(1 + RAND() * 6), 
                'Colegio ', 'Liceo ', 'U.E. ', 'Instituto ', 'Academia ', 'Escuela Técnica '),
            
            ELT(FLOOR(1 + RAND() * 25), 
                'San Agustín', 'Caminito', 'Simón Bolívar', 'Andrés Bello', 'Los Próceres', 
                'Don Bosco', 'Santa María', 'San Francisco', 'La Salle', 'El Libertador', 
                'Gran Mariscal', 'Nuestra Señora', 'San Antonio', 'Las Américas', 'Montalbán', 
                'El Paraíso', 'Santa Rosa', 'Los Andes', 'Canaima', 'Ávila', 
                'San Ignacio', 'Loyola', 'Mater Dei', 'Santiago León', 'Humboldt')
        );
        
        -- Actualizamos el registro donde el ID coincide
        UPDATE escuela 
        SET nombre_escuela = nuevo_nombre 
        WHERE id_escuela = i;
        
        SET i = i + 1;
    END WHILE;
END$$

DELIMITER ;

-- Ejecutar el cambio de nombres
SET SQL_SAFE_UPDATES = 0; -- Desactivar seguridad momentáneamente para updates masivos
CALL ActualizarNombresEscuelasRealistas();
SET SQL_SAFE_UPDATES = 1;


SET SQL_SAFE_UPDATES = 0; -- Desactivar protección para permitir updates masivos

UPDATE justificacion
SET motivo = ELT(FLOOR(1 + RAND() * 12), 
    'Cita médica programada con especialista.',
    'Problema de salud repentino (virosis/gripe).',
    'Falla mecánica en el transporte público.',
    'Calamidad doméstica urgente.',
    'Asistencia a trámites legales obligatorios.',
    'Fallecimiento de un familiar cercano.',
    'Accidente de tránsito leve camino a la universidad.',
    'Representación de la universidad en evento deportivo.',
    'Cita odontológica de emergencia.',
    'Problemas graves de conexión/electricidad en su zona.',
    'Cuidado de familiar enfermo.',
    'Choque de horario con actividad extracurricular autorizada.'
);

SET SQL_SAFE_UPDATES = 1; -- Volver a activar protección

SET SQL_SAFE_UPDATES = 0; -- Desactivamos el freno de seguridad

UPDATE sesion_clase
SET tema = CONCAT(
    -- Prefijo para darle variedad (Tipo de clase)
    ELT(FLOOR(1 + RAND() * 4), 'Clase Magistral: ', 'Laboratorio: ', 'Seminario: ', 'Taller Práctico: '),
    
    -- Tema académico
    ELT(FLOOR(1 + RAND() * 20), 
        'Introducción a la Programación',
        'Cálculo Diferencial e Integral',
        'Física Mecánica y Leyes de Newton',
        'Diseño de Bases de Datos Relacionales',
        'Termodinámica Aplicada',
        'Análisis de Circuitos Eléctricos',
        'Estructuras de Datos y Algoritmos',
        'Química General',
        'Estadística y Probabilidad',
        'Gerencia de Proyectos de Ingeniería',
        'Inteligencia Artificial y Machine Learning',
        'Redes de Computadoras y Protocolos',
        'Resistencia de Materiales',
        'Ética Profesional en Ingeniería',
        'Metodología de la Investigación',
        'Sistemas Operativos',
        'Arquitectura de Software',
        'Ecuaciones Diferenciales',
        'Seguridad Informática',
        'Desarrollo Web Full Stack'
    )
);

SET SQL_SAFE_UPDATES = 1; -- Volvemos a activar la seguridad

SET SQL_SAFE_UPDATES = 0; -- Desactivar protección para permitir updates masivos

UPDATE incidencia
SET descripcion = ELT(FLOOR(1 + RAND() * 30),
    -- 1 al 10: SALUD
    'El estudiante no asistió por presentar cuadro de fiebre alta y malestar general.',
    'Inasistencia por cita médica odontológica programada para extracción de muela.',
    'Reposo médico de 3 días por diagnóstico de bronquitis aguda.',
    'Presentó reacción alérgica severa y tuvo que ir a urgencias.',
    'Cita con el oftalmólogo para revisión de fórmula de lentes.',
    'Dolor estomacal fuerte e infección intestinal confirmada.',
    'Se reporta inasistencia por contagio de varicela, requiere aislamiento.',
    'Terapia física obligatoria por lesión deportiva en el tobillo.',
    'Migraña severa que le impide asistir a las actividades académicas.',
    'Cirugía ambulatoria programada para la fecha de hoy.',

    -- 11 al 17: TRANSPORTE
    'No pudo llegar al colegio por falta de transporte público en su zona.',
    'El vehículo familiar sufrió una avería mecánica camino a la institución.',
    'Inasistencia debido a las fuertes lluvias que inundaron su calle.',
    'Bloqueo en la avenida principal impidió el paso del transporte escolar.',
    'Paro de transportistas que afectó la movilidad en su sector.',
    'Accidente de tránsito en la autopista generó retraso de 3 horas.',
    'El bus escolar no pasó a recogerlo por problemas logísticos.',

    -- 18 al 22: FAMILIA / PERSONAL
    'Viaje familiar de emergencia por fallecimiento de un pariente cercano.',
    'Calamidad doméstica urgente que requirió la presencia del estudiante.',
    'El estudiante tuvo que cuidar a su hermano menor por enfermedad de los padres.',
    'Asistencia a matrimonio de familiar directo fuera de la ciudad.',
    'Problemas familiares graves que impidieron su asistencia hoy.',

    -- 23 al 26: TRÁMITES
    'Cita para renovación de pasaporte en oficina de identificación.',
    'Trámite obligatorio de documento de identidad (cédula) en el registro civil.',
    'Entrevista para visa en el consulado programada desde hace meses.',
    'Asistencia a citación judicial como testigo en proceso familiar.',

    -- 27 al 30: SIN JUSTIFICAR / OTROS
    'El estudiante faltó sin presentar justificación previa hasta el momento.',
    'Se quedó dormido y no alcanzó a llegar a la primera hora.',
    'Confusión con el horario de clases, pensó que era día feriado.',
    'Problemas de conexión eléctrica en su hogar afectaron su preparación.'
);

SET SQL_SAFE_UPDATES = 1; -- Volvemos a activar la seguridad

SET SQL_SAFE_UPDATES = 0; -- Desactivar seguridad temporalmente

UPDATE participacion_clase
SET comentario = CASE 
    WHEN puntos_puntuacion >= 18 THEN 'Excelente aporte, demostró dominio total del tema y liderazgo.'
    WHEN puntos_puntuacion BETWEEN 15 AND 17 THEN 'Buena participación, argumentos sólidos pero puede profundizar más.'
    WHEN puntos_puntuacion BETWEEN 11 AND 14 THEN 'Participación regular, respondió parcialmente a las preguntas.'
    ELSE 'Aporte deficiente, requiere repasar los conceptos fundamentales.'
END;

SET SQL_SAFE_UPDATES = 1; -- Activar seguridad de nuevo



