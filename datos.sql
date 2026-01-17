-- ==========================================================
-- 1. LIMPIEZA TOTAL (Reset de IDs)
-- ==========================================================
SET FOREIGN_KEY_CHECKS = 0;

TRUNCATE TABLE participacion_clase;
TRUNCATE TABLE incidencia;
TRUNCATE TABLE justificacion;
TRUNCATE TABLE asistencia;
TRUNCATE TABLE sesion_clase;
TRUNCATE TABLE escuela;
TRUNCATE TABLE facultad;
TRUNCATE TABLE sede;

SET FOREIGN_KEY_CHECKS = 1;

-- ==========================================================
-- 2. PROCEDIMIENTO OPTIMIZADO
-- ==========================================================
DELIMITER //

DROP PROCEDURE IF EXISTS GenerarDatosMasivosReales //

CREATE PROCEDURE GenerarDatosMasivosReales()
BEGIN
    DECLARE i INT DEFAULT 1;
    DECLARE var_region VARCHAR(20);
    DECLARE var_estado VARCHAR(20);
    DECLARE rand_val FLOAT;
    
    DECLARE var_fecha_sesion DATE;
    DECLARE var_hora_inicio TIME;
    DECLARE var_hora_fin TIME;
    DECLARE var_hora_llegada TIME;
    
    DECLARE nombre_random VARCHAR(50);
    DECLARE apellido_random VARCHAR(50);
    DECLARE nombre_completo VARCHAR(150);

    -- OPTIMIZACIÓN DE VELOCIDAD
    SET autocommit = 0;
    SET FOREIGN_KEY_CHECKS = 0;
    SET UNIQUE_CHECKS = 0;

    -- 1. Generar 20 SEDES 
    SET i = 1;
    WHILE i <= 20 DO
        SET rand_val = RAND();
        IF rand_val < 0.33 THEN SET var_region = 'Norte';
        ELSEIF rand_val < 0.66 THEN SET var_region = 'Centro';
        ELSE SET var_region = 'Sur';
        END IF;
        
        INSERT INTO sede (nombre_sede, region) 
        VALUES (CONCAT('Campus ', ELT(1 + FLOOR(RAND() * 5), 'Bicentenario', 'Metropolitano', 'Central', 'Innovación', 'Tecnológico'), ' - Sede ', i), var_region);
        SET i = i + 1;
    END WHILE;

    -- 2. Generar 60 FACULTADES
    SET i = 1;
    WHILE i <= 60 DO
        INSERT INTO facultad (nombre_facultad, id_sede) 
        VALUES (
            CONCAT('Facultad de ', ELT(1 + FLOOR(RAND() * 15), 
                'Ingeniería y Arquitectura', 'Ciencias de la Salud', 'Ciencias Jurídicas', 'Negocios Globales', 
                'Artes Escénicas', 'Ciencias Agrarias', 'Psicología', 'Educación', 
                'Comunicaciones', 'Hospitalidad y Turismo', 'Medicina Humana', 'Odontología',
                'Ingeniería de Minas', 'Derecho Corporativo', 'Diseño y Arte'
            )),
            FLOOR(1 + RAND() * 20)
        );
        SET i = i + 1;
    END WHILE;

    -- 3. Generar 100 ESCUELAS
    SET i = 1;
    WHILE i <= 100 DO
        INSERT INTO escuela (nombre_escuela, id_facultad) 
        VALUES (
            CONCAT('Escuela Profesional de ', ELT(1 + FLOOR(RAND() * 20), 
                'Ingeniería de Sistemas', 'Ingeniería Civil', 'Medicina', 'Derecho Penal', 
                'Marketing Digital', 'Diseño Gráfico', 'Psicología Clínica', 'Contabilidad', 
                'Administración de Empresas', 'Enfermería', 'Nutrición', 'Turismo',
                'Ingeniería Industrial', 'Economía', 'Periodismo', 'Publicidad',
                'Arquitectura de Interiores', 'Biología', 'Veterinaria', 'Zootecnia'
            )),
            FLOOR(1 + RAND() * 60)
        );
        SET i = i + 1;
    END WHILE;

    -- 4. Generar 1000 SESIONES
    SET i = 1;
    WHILE i <= 1000 DO
        SET var_fecha_sesion = DATE_ADD('2026-03-01', INTERVAL FLOOR(RAND() * 60) DAY);
        SET var_hora_inicio = SEC_TO_TIME(25200 + FLOOR(RAND() * 46800));
        SET var_hora_fin = ADDTIME(var_hora_inicio, '02:00:00');

        INSERT INTO sesion_clase (id_escuela, fecha_sesion, hora_inicio, hora_fin, tema) 
        VALUES (
            FLOOR(1 + RAND() * 100), 
            var_fecha_sesion, 
            var_hora_inicio, 
            var_hora_fin,
            CONCAT('Unidad ', FLOOR(1+RAND()*4), ': ', ELT(1 + FLOOR(RAND() * 10), 
                'Introducción al curso', 'Metodologías Ágiles', 'Análisis de Datos', 'Legislación Vigente', 
                'Dinámica de Grupos', 'Estudios de Caso', 'Laboratorio Práctico', 'Revisión de Proyectos',
                'Examen Parcial', 'Desarrollo Sostenible'
            ))
        );
        SET i = i + 1;
    END WHILE;

    -- 5. Generar 3000 ASISTENCIAS
    SET i = 1;
    WHILE i <= 3000 DO
        SET nombre_random = ELT(1 + FLOOR(RAND() * 20), 'Santiago', 'Mateo', 'Sebastián', 'Leonardo', 'Matías', 'Diego', 'Daniel', 'Miguel', 'Alejandro', 'Gabriel', 'Sofía', 'Valentina', 'Isabella', 'Camila', 'Valeria', 'Mariana', 'Gabriela', 'Sara', 'Victoria', 'Martina');
        SET apellido_random = ELT(1 + FLOOR(RAND() * 20), 'Gonzales', 'Muñoz', 'Rojas', 'Diaz', 'Perez', 'Soto', 'Contreras', 'Silva', 'Martinez', 'Sepulveda', 'Morales', 'Rodriguez', 'Lopez', 'Fuentes', 'Hernandez', 'Torres', 'Araya', 'Flores', 'Espinoza', 'Castillo');
        SET nombre_completo = CONCAT(nombre_random, ' ', apellido_random);
        
        SET @id_sesion_rand = FLOOR(1 + RAND() * 1000);
        SET var_hora_llegada = SEC_TO_TIME(25200 + FLOOR(RAND() * 54000));

        SET rand_val = RAND();
        IF rand_val < 0.70 THEN SET var_estado = 'Presente';
        ELSEIF rand_val < 0.85 THEN SET var_estado = 'Tarde';
        ELSEIF rand_val < 0.95 THEN SET var_estado = 'Ausente';
        ELSE SET var_estado = 'Justificado';
        END IF;

        INSERT INTO asistencia (id_sesion, nombre_estudiante, estado, hora_llegada) 
        VALUES (@id_sesion_rand, nombre_completo, var_estado, var_hora_llegada);

        IF var_estado IN ('Ausente', 'Justificado') THEN
            INSERT INTO justificacion (id_asistencia, motivo) 
            VALUES (LAST_INSERT_ID(), ELT(1 + FLOOR(RAND() * 6), 'Salud', 'Trabajo', 'Calamidad Doméstica', 'Viaje', 'Trámite Administrativo', 'Sin motivo aparente'));
        END IF;
        
        IF var_estado = 'Ausente' THEN
             INSERT INTO incidencia (id_sesion, nombre_estudiante, descripcion) 
             VALUES (@id_sesion_rand, nombre_completo, 'El estudiante no se presentó ni notificó.');
        END IF;

        IF var_estado IN ('Presente', 'Tarde') THEN
            INSERT INTO participacion_clase (id_sesion, nombre_estudiante, tipo_participacion, puntos_puntuacion, comentario) 
            VALUES (
                @id_sesion_rand, 
                nombre_completo, 
                ELT(1 + FLOOR(RAND() * 4), 'Pregunta', 'Aporte', 'Ejercicio', 'Otro'), 
                -- CAMBIO AQUÍ: Genera un entero entre 1 y 10
                FLOOR(1 + RAND() * 10), 
                ELT(1 + FLOOR(RAND() * 4), 'Correcto', 'Interesante aporte', 'Necesita mejorar', 'Excelente')
            );
        END IF;

        SET i = i + 1;
    END WHILE;

    COMMIT;
    SET FOREIGN_KEY_CHECKS = 1;
    SET UNIQUE_CHECKS = 1;
    SET autocommit = 1;

END //

DELIMITER ;

-- ==========================================================
-- 3. EJECUTAR
-- ==========================================================
CALL GenerarDatosMasivosReales();